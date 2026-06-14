from django.db import migrations

def migrate_feedback_data(apps, schema_editor):
    FeedbackType = apps.get_model('api_v1', 'FeedbackType')
    Feedback = apps.get_model('api_v1', 'Feedback')

    # Ensure default types exist with correct IDs and names
    types_to_ensure = {
        1: '功能建議 (想要更多)',
        2: 'Bug 回報 (系統出錯)',
        3: '其他',
        4: '場地/活動問題',
    }
    
    for tid, tname in types_to_ensure.items():
        # Using update_or_create to ensure both ID and Name are aligned
        FeedbackType.objects.update_or_create(id=tid, defaults={'name': tname})

    # Migrate feedback records from old string 'type' to 'feedback_type' FK
    for fb in Feedback.objects.all():
        old_type = fb.type
        if not old_type:
            fb.feedback_type_id = 3  # 其他
        elif '建議' in old_type:
            fb.feedback_type_id = 1
        elif '錯誤' in old_type or 'Bug' in old_type or '問題' in old_type:
            fb.feedback_type_id = 2
        elif '場地' in old_type:
            fb.feedback_type_id = 4
        else:
            fb.feedback_type_id = 3
        fb.save()

def reverse_migrate_feedback_data(apps, schema_editor):
    Feedback = apps.get_model('api_v1', 'Feedback')
    # Revert FK to string representation
    for fb in Feedback.objects.all():
        if fb.feedback_type:
            if fb.feedback_type.id == 1:
                fb.type = '建議'
            elif fb.feedback_type.id == 2:
                fb.type = '錯誤'
            elif fb.feedback_type.id == 4:
                fb.type = '場地'
            else:
                fb.type = '其他'
        else:
            fb.type = '其他'
        fb.save()

class Migration(migrations.Migration):

    dependencies = [
        ('api_v1', '0020_alter_feedbacktype_options_feedback_feedback_type'),
    ]

    operations = [
        migrations.RunPython(migrate_feedback_data, reverse_migrate_feedback_data),
    ]
