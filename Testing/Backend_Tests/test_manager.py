import requests



def test_add_manager():
    url = 'http://127.0.0.1:8000/register'
    headers = {'Content-Type': 'application/json'}
    json = {
        "user_type": "manager",
        "user_email": "testmanager@gmail.com",
        "user_password": "test_password"
    }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get('detail') == "Manager Registered Successfully"
        assert 'id' in response_json
        assert response_json['id']['manager_id'] == 1
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_manager():
    url = 'http://127.0.0.1:8000/managers'
    headers = {'Content-Type': 'application/json'}
    response = requests.get(url, headers=headers)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = [{
            "manager_id": 1,
            "manager_email": "testmanager@gmail.com",
            "manager_password": "test_password"
        }]
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"



def test_update_manager():
    url = 'http://127.0.0.1:8000/managers'
    headers = {'Content-Type': 'application/json'}
    json = {
        "manager": {              
            "manager_id": 1,
            "manager_email": "testmanager@gmail.com",
            "manager_password": "test_password",
            "manager_firstname": "test",
            "manager_surname": "tester",
            "manager_contact_number": "012345",
            "manager_image": "something"
        }
    }
    
    response = requests.put(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get('detail') == "Manager Registered Successfully"
        assert 'id' in response_json
        assert response_json['id']['manager_id'] == 1
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"



def test_delete_manager():
    url = 'http://127.0.0.1:8000/managers/1'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {
            "message":"Manager and manager info with ID 1 has been deleted"
        }
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"




def test_z_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200
    