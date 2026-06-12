import { create } from 'zustand';
import gamesApi from '../api/games';
import axiosClient from '../api/axiosClient';

const formatParty = (party) => {
  const reverseLevelMap = {
    'C': '休閒', 'B': '業餘', 'A': '高手', 'S': '高手',
    '新手': '休閒', '休閒': '休閒', '高手': '高手'
  };
  const rawType = party.type || party.sport_type || party.sport_name || '運動';
  const originalLevel = party.level || party.target_level || 'C';
  const rawLevel = reverseLevelMap[originalLevel] || originalLevel;
  
  let venueStatus = 'pending';
  if (party.booking_status === '已佔到/已預約' || party.booking_status === 'confirmed') {
    venueStatus = 'confirmed';
  } else if (party.booking_status === '未佔到/未預約' || party.booking_status === 'failed') {
    venueStatus = 'failed';
  }
  
  return {
    ...party,
    id: party.id,
    venueStatus,
    title: party.game_name || party.title || '無標題揪團',
    type: rawType,
    level: rawLevel,
    genderLimit: party.genderLimit || party.gender_limit || '不限',
    location: party.location || party.venue_name || '地點未定',
    time: party.time || (party.booking_date ? `${party.booking_date} ${party.time_slot || ''}` : '時間未定'),
    currentPlayers: party.currentPlayers ?? party.current_players ?? 0,
    maxPlayers: party.maxPlayers ?? party.most_players ?? 6,
    currentWaitlist: party.currentWaitlist ?? party.current_waitlist ?? 0,
    maxWaitlist: party.maxWaitlist ?? party.max_waitlist ?? 2,
    description: party.game_note || party.description,
    participants: party.participants || [],
    participant_ids: party.participant_ids || [],
    waitlist_ids: party.waitlist_ids || [],
    creator_id: party.creator_id,
  };
};

const useGameStore = create((set, get) => ({
  parties: [],
  isPageLoading: false,
  sseConnected: false,
  eventSource: null,
  lastUpdate: null,

  setParties: (parties) => set({ parties }),

  updateParty: (party) => set((state) => {
    const formattedParty = formatParty(party);
    const exists = state.parties.some(p => String(p.id) === String(party.id));
    const nextParties = exists 
      ? state.parties.map(p => String(p.id) === String(party.id) ? formattedParty : p)
      : [...state.parties, formattedParty];
    return { parties: nextParties, lastUpdate: Date.now() };
  }),

  fetchParties: async (showLoading = true) => {
    if (showLoading) set({ isPageLoading: true });
    try {
      const data = await gamesApi.getGames();
      const list = Array.isArray(data) ? data : (data.results || []);
      const formattedGames = list.map(formatParty);
      set({ parties: formattedGames, isPageLoading: false });
    } catch (err) {
      console.error('Failed to fetch parties:', err);
      set({ isPageLoading: false });
    }
  },

  connectSSE: () => {
    if (get().sseConnected) {
      console.log('[PartyDetail] [SSE] Already connected, skipping duplicate connection.');
      return;
    }

    const apiBase = axiosClient.defaults.baseURL || import.meta.env.VITE_API_BASE_URL || 'http://localhost:8088/api/';
    const streamUrl = `${apiBase}games/stream/`;
    console.log('[PartyDetail] [SSE] Attempting to connect to SSE stream:', streamUrl);
    const eventSource = new EventSource(streamUrl);

    eventSource.onopen = () => {
      console.log('[PartyDetail] [SSE] Connection opened successfully to:', streamUrl);
      set({ sseConnected: true });
    };

    eventSource.onmessage = (event) => {
      try {
        const updates = JSON.parse(event.data);
        console.log('[PartyDetail] [SSE] Received event data:', updates);
        if (Array.isArray(updates)) {
          const state = get();
          let hasGlobalChange = false;
          let needsFullFetch = false;

          const currentIds = new Set(state.parties.map(p => p.id));
          for (const u of updates) {
            if (!u.deleted && !currentIds.has(u.id)) {
              needsFullFetch = true;
              break;
            }
          }

          if (needsFullFetch) {
            console.log('[PartyDetail] [SSE] Found new game match ID. Triggering full fetch...');
            state.fetchParties(false);
            return;
          }

          const updateMap = new Map(updates.map(u => [u.id, u]));
          const nextParties = state.parties.filter(prev => {
            const u = updateMap.get(prev.id);
            if (u && u.deleted) {
              console.log(`[PartyDetail] [SSE] Game ${prev.id} deleted. Removing from store.`);
              hasGlobalChange = true;
              return false;
            }
            return true;
          }).map(prev => {
            const u = updateMap.get(prev.id);
            if (!u) return prev;

            const isChanged = 
              prev.currentPlayers !== u.cp ||
              prev.match_status !== u.ms ||
              prev.booking_status !== u.bs ||
              JSON.stringify(prev.participant_ids) !== JSON.stringify(u.p_ids);

            if (isChanged) {
              console.log(`[PartyDetail] [SSE] Game ${prev.id} changed:`, {
                before: {
                  currentPlayers: prev.currentPlayers,
                  match_status: prev.match_status,
                  booking_status: prev.booking_status,
                  participant_ids: prev.participant_ids
                },
                after: {
                  currentPlayers: u.cp,
                  match_status: u.ms,
                  booking_status: u.bs,
                  participant_ids: u.p_ids
                }
              });
              hasGlobalChange = true;
              let venueStatus = 'pending';
              if (u.bs === '已佔到/已預約' || u.bs === 'confirmed') {
                venueStatus = 'confirmed';
              } else if (u.bs === '未佔到/未預約' || u.bs === 'failed') {
                venueStatus = 'failed';
              }

              return {
                ...prev,
                currentPlayers: u.cp,
                maxPlayers: u.mp,
                match_status: u.ms,
                booking_status: u.bs,
                participant_ids: u.p_ids,
                venueStatus
              };
            }
            return prev;
          });

          if (hasGlobalChange) {
            console.log('[PartyDetail] [SSE] Global changes applied to store.');
            set({ parties: nextParties, lastUpdate: Date.now() });
          } else {
            console.log('[PartyDetail] [SSE] No changes detected in this event.');
          }
        }
      } catch (err) {
        console.error('[PartyDetail] [SSE] Parsing error:', err);
      }
    };

    eventSource.onerror = (err) => {
      console.error('[PartyDetail] [SSE] Connection error/disconnected. EventSource readyState:', eventSource.readyState, err);
      set({ sseConnected: false });
    };

    set({ eventSource, sseConnected: true });
  },

  disconnectSSE: () => {
    const { eventSource } = get();
    if (eventSource) {
      eventSource.close();
    }
    set({ eventSource: null, sseConnected: false });
  }
}));

export default useGameStore;
