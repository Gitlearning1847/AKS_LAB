import pytest
from app import app, db, User

@pytest.fixture
def client():
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'  # in-memory DB
    with app.app_context():
        db.create_all()
        # Create a test user
        user = User(username='testuser', password='testpass')
        db.session.add(user)
        db.session.commit()

    with app.test_client() as client:
        yield client

def test_home_route(client):
    response = client.get('/')
    assert response.status_code == 200

def test_login_get(client):
    response = client.get('/login')
    assert response.status_code == 200

def test_login_post_valid(client):
    response = client.post('/login', data={
        'username': 'testuser',
        'password': 'testpass'
    })
    assert response.status_code == 200
    assert b"Welcome testuser" in response.data

def test_login_post_invalid(client):
    response = client.post('/login', data={
        'username': 'wronguser',
        'password': 'wrongpass'
    })
    assert response.status_code == 200
    assert b"Invalid login" in response.data

def test_search_post(client):
    response = client.post('/search', data={'query': 'example'})
    assert response.status_code == 200
    assert b"example" in response.data

def test_contact_get(client):
    response = client.get('/contact')
    assert response.status_code == 200