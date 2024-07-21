# Roulette API Documentation

## Prerequisites
- Ensure you have Ruby and Rails installed.
- Install SQLite3 for the database.
- Install Postman for API testing.

## Setup Instructions

1. **Clone the Repository**
   ```sh
   git clone https://github.com/mrmind3312/roulette-api.git
   cd roulette-api
   ```

2. **Install Dependencies**
   ```sh
   bundle install
   ```

3. **Setup Database**
   Create the database and seed it with initial data.
   ```sh
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Generate Devise JWT Secret Key**
   Since the master key is not included in the repository, you need to create credentials.
   ```sh
   rails secret
   ```
   Copy the generated secret string and create the `devise_jwt_secret_key`:
   ```sh
   EDITOR="code --wait" bin/rails credentials:edit
   ```
   Add the following entry:
   ```yaml
   devise_jwt_secret_key: <your_generated_secret>
   ```

5. **Start the Rails Server**
   ```sh
   rails server
   ```
   The API will be accessible at `http://localhost:3000`.

## Authentication

The application uses JWT for authentication. After a successful login, the JWT token is returned in the `Authorization` header. This token is required for all subsequent requests.

## Postman Collection

A Postman collection is provided for testing the API. Import the `Roulette API.postman_collection.json` file into Postman to access predefined requests.

### Postman Login Request

1. **Login**
   - URL: `{{URL}}/api/auth/login`
   - Method: POST
   - Body:
     ```json
     {
       "user": {
         "email": "developer@developer.cl",
         "password": "192f6ce863aed79a"
       }
     }
     ```

2. **Postman Test Script**
   This script extracts the JWT token from the `Authorization` header and sets it as an environment variable.
   ```javascript
   // Check if the response contains the Authorization header
   const authHeader = pm.response.headers.get('Authorization');
   if (authHeader) {
       pm.environment.set('TOKEN', authHeader.split(' ')[1]);
   } else {
       console.log('Authorization header not found in the response');
   }
   ```

## API Endpoints

### 1. **Create Users, Services, and Hours**
   Populates the database with initial data.
   ```sh
   rails db:seed
   ```
   If you want to change the services and required times, please check and modify: `db/seeds/001_services.rb`. Also, if you want to change users, adjust `db/seeds/002_users.rb`.

### 2. **Manage User Availability**
   This section covers the endpoints to manage user availability by week, day, and hour.

   - **Create Availability**
     - URL: `{{URL}}/api/v1/users/:user_id/availabilities`
     - Method: POST
     - Headers: `Authorization: Bearer {{TOKEN}}`
     - Body:
       ```json
       {
          "day": 1,
          "week": 1,
          "month": 1,
          "year": 2024,
          "available": true,
          "services_id": null, // This param could be optional
          "catalog_hours_id": 2
       }
       ```

   - **Get Availability**
     - URL: `{{URL}}/api/availabilities`
     - Method: GET
     - Headers: `Authorization: Bearer {{TOKEN}}`

   - **Update Availability**
     - URL: `{{URL}}/api/v1/users/:user_id/availabilities/:id`
     - Method: PUT
     - Headers: `Authorization: Bearer {{TOKEN}}`
     - Body:
       ```json
       {
          "day": 1,
          "week": 1,
          "month": 1,
          "year": 2024,
          "available": false,
          "services_id": 10, // This param could be optional
          "catalog_hours_id": 2
       }
       ```

   - **Delete Availability**
     - URL: `{{URL}}/api/v1/users/:user_id/availabilities/:id`
     - Method: DELETE
     - Headers: `Authorization: Bearer {{TOKEN}}`

## Auto-Assign Hours
The API auto-assigns hours based on the required service hours and the available hours set by the day of the week. The specifics of this process are handled internally by the application logic.

---

Ensure you have the Postman collection imported and the environment variables (`URL`, `TOKEN`) set appropriately to interact with the API. This documentation provides the necessary setup and usage instructions to get started with the Roulette API.
