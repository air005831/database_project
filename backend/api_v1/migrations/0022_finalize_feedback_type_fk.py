from django.db import migrations, models
import django.db.models.deletion

class Migration(migrations.Migration):

    dependencies = [
        ('api_v1', '0021_data_migrate_feedbacks'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='feedback',
            name='type',
        ),
        migrations.RenameField(
            model_name='feedback',
            old_name='feedback_type',
            new_name='type',
        ),
        migrations.AlterField(
            model_name='feedback',
            name='type',
            field=models.ForeignKey(
                db_column='feedback_type_id',
                default=3,
                on_delete=django.db.models.deletion.PROTECT,
                related_name='feedbacks',
                to='api_v1.feedbacktype',
            ),
        ),
    ]
