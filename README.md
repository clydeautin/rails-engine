# Rails Engine

Rails Engine is an e-commerce backend API designed to provide robust and efficient data management for e-commerce platforms. This project was developed as a team effort to expose data via RESTful APIs for frontend consumption. It includes features for managing e-commerce data like merchants, items, invoices, and transactions while ensuring high performance and scalability.

## Features

* RESTful API Endpoints: Provides well-structured endpoints to fetch and manage e-commerce data.
* Optimized Database Queries: Uses advanced ActiveRecord techniques to ensure efficient data retrieval and manipulation.
* Comprehensive API Documentation: Detailed API docs created using Postman, enabling easy consumption by frontend developers.
* Performance Enhancements: Implements caching mechanisms to optimize response times for frequently accessed data.
* Robust Testing: Includes test coverage for API endpoints using tools like RSpec, Webmock, and VCR.

 ## Technology Stack
*	Programming Language: Ruby
*	Framework: Ruby on Rails
*	API Clients: Faraday
*	Testing Tools: RSpec, Webmock, VCR, Postman
*	Database: PostgreSQL

## Getting Started

Follow these steps to set up the project on your local machine:

### Prerequisites
*	Ruby 3.x
* Rails 6.x
*	PostgreSQL
*	Bundler

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/clydeautin/rails-engine.git
   cd rails-engine
2. Install dependencies
  ``` bundle install ```
3. Set up the database
   ```rails db:{create,migrate,seed}```
4. Start the Rails server
   ``` rails server```
The API will be accessible at http://localhost:3000.

## API Documentation

All API endpoints are documented and tested using Postman. You can import the Postman collection from the repository to view and test available endpoints.

Example Endpoints
*	Get All Merchants: GET /api/v1/merchants
*	Get Merchant by ID: GET /api/v1/merchants/:id
*	Search for Items: GET /api/v1/items/find_all?name=<query>
*	Create an Invoice: POST /api/v1/invoices

## Performance Optimization

To improve performance:
*	Caching mechanisms were implemented for frequent queries.
*	Advanced ActiveRecord techniques were used to reduce query execution time.
