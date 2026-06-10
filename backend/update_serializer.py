import os

filepath = r"C:\Users\User\Documents\antigravity\db_all\backend\api_v1\serializers.py"

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# Add gender to serializer
search_1 = "      age = serializers.ReadOnlyField(source='user.age')"
replace_1 = "      age = serializers.ReadOnlyField(source='user.age')\n      gender = serializers.ReadOnlyField(source='user.gender')"

search_2 = "fields = ('id', 'phone', 'name', 'age', 'level')"
replace_2 = "fields = ('id', 'phone', 'name', 'age', 'gender', 'level')"

content = content.replace(search_1, replace_1)
content = content.replace(search_2, replace_2)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)
