## Getting Started
This project is built with Ruby(3.2.2), Rails(Rails 7.0.8) and uses PostgreSQL as the database. It includes Devise for authentication, GraphQL mutations for creating and fetching books, along with pagination functionality.

### Prerequisites
Before you begin, make sure you have the following installed  on your system:

- Ruby: You can install Ruby using a version manager like RVM or rbenv.
- PostgreSQL: Ensure you have PostgreSQL installed.


### Project Setup
Follow these steps to set up and run the project on your local machine:

1. Clone the Repository:

```bash
git clone <repository-url>
cd project-directory
```

2. Install Dependencies:
```
bundle install
```

3. Database Setup:
Create a PostgreSQL database and update the database configuration in config/database.yml with your database credentials.

4. Run database migrations to set up the necessary tables:
```
rails db:migrate
```

5. Run the Rails Server:
``````
rails server
``````

### Access GraphQL Endpoint in development:
The GraphQL endpoint can be accessed at http://localhost:3000/graphql.


### User account
Open `http://localhost:3000` in your browser and sign up for a new user account. Use this account to get the user's token  through GraphQL `signIn` mutation. Then, use the user's token in the other request to create, update and delete books.


# GraphQL Queries

### Sign In Query
Initially, the user must  sign up using the application first. Then, the login credential can be used in the GraphQL queries for sign in.

```
mutation {
  signIn(input: {
    email: "test@example.com",
    password: "changeMe!1234" }
  ) {
    user {
      id
      email
    }
    success
    token
  }
}
```

```
// Response for valid login request
{
  "data": {
    "signIn": {
      "user": {
        "id": "1",
        "email": "test@example.com"
      },
      "success": true,
      "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.YEAl2TqCI3I_Ql8Fp10KahzwMN7jrn_scbh984hqNrM"
    }
  }
}
```

## GraphQL Mutations/Queries for Book
This included queries and mutations for the CRUD operations on Book. The '`books` and `book` queries work normally.
But, in the following book mutations i.e `createBook`, `updateBook` and `deleteBook`,  authorization token are required to be present in the request header for authorization i.e `{"Authorization" => "Bearer <token_value>`. The token can be obtained from `signIn` mutation with valid email and password.

### List Books
This query returns books. Here, `page` and `perPage` options are optional and would return the first page with 10 records by default.

```
query {
  books(page: 2, perPage:3) {
    id
    title
    yearPublished
    authors
    description
    genre
    user {
      id
      email
    }
  }
}
```

```
//Output
{
  "data": {
    "books": [
      {
        "id": "4",
        "title": "Antic Hay",
        "yearPublished": 1909,
        "authors": "Ed Beier",
        "description": "Laborum recusandae nemo a.",
        "genre": "Textbook",
        "user": {
          "id": "5",
          "email": "ezequiel@mosciski.test"
        }
      },
      {
        "id": "5",
        "title": "Such, Such Were the Joys",
        "yearPublished": 1975,
        "authors": "Fr. Jaimie Tillman",
        "description": "Ea explicabo nam iste.",
        "genre": "Western",
        "user": {
          "id": "6",
          "email": "eusebia_littel@roob-quitzon.test"
        }
      },
      {
        "id": "6",
        "title": "A Swiftly Tilting Planet",
        "yearPublished": 1984,
        "authors": "Nancey Keeling",
        "description": "Fugit aut esse quam.",
        "genre": "Horror",
        "user": {
          "id": "7",
          "email": "elbert@spinka.test"
        }
      }
    ]
  }
}
```


### Fetch a book
```
query {
  book(id: 13){
    id
    title
    yearPublished
    authors
    description
    genre
    user {
      id
      email
    }
  }
}
```

```
// Output
{
  "data": {
    "book": {
      "id": "13",
      "title": "Sample Book 345",
      "yearPublished": 2023,
      "authors": "John Doe",
      "description": "A sample book description.",
      "genre": "Drama",
      "user": {
        "id": "1",
        "email": "test@example.com"
      }
    }
  }
}
```


### Add a book
```
mutation {
  createBook(input: {
    title: "#{book_attributes[:title]}",
    yearPublished: #{book_attributes[:year_published]},
    authors: "#{book_attributes[:authors]}",
    description: "#{book_attributes[:describe]}",
    genre: "#{book_attributes[:genre]}",
  })
  {
    book {
      id
      title
      yearPublished
      authors
      description
      genre
      user {
        id
        email
      }
    }
    success
    errors
  }
}
```

### Update a book
```
mutation {
  updateBook(input: {
    id: #{book.id}
    title: "#{book.title}",
    yearPublished: #{book.year_published},
    authors: "#{book.authors}",
    description: "#{book.description}",
    genre: "#{book.genre}",
  })
  {
    book {
      id
      title
      yearPublished
      authors
      description
      genre
      user {
        id
        email
      }
    }
    success
    errors
  }
}
```

### Delete a book
```
mutation {
  deleteBook(input: {
    id: #{book.id}
  })
  {
    book {
      id
      title
      yearPublished
      authors
      description
      genre
      user {
        id
        email
      }
    }
    success
    errors
  }
}
```
