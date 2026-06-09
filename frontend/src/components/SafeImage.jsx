import React, { useState } from 'react';

/**
 * SafeImage Component
 * A wrapper around <img> that provides a fallback if the image fails to load or the src is empty.
 */
const SafeImage = ({ src, alt, style, className }) => {
  const [error, setError] = useState(false);

  // Fallback UI for when the image is missing or fails to load
  const renderFallback = () => (
    <div 
      style={{ 
        display: 'flex', 
        alignItems: 'center', 
        justifyContent: 'center', 
        backgroundColor: '#f1f5f9', 
        color: '#94a3b8',
        fontSize: '12px',
        textAlign: 'center',
        padding: '10px',
        borderRadius: style?.borderRadius || '4px',
        ...style 
      }} 
      className={className}
    >
      無圖片
    </div>
  );

  if (error || !src) {
    return renderFallback();
  }

  return (
    <img
      src={src}
      alt={alt}
      style={style}
      className={className}
      onError={() => setError(true)}
    />
  );
};

export default SafeImage;
