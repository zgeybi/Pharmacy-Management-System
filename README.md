# Pharmacy Management System

## Overview

The Pharmacy Management System is designed to streamline and automate pharmacy operations. It helps manage inventory, suppliers, patients, orders, and employees efficiently using a PostgreSQL database.

## Features

- **Suppliers Management:** Manage supplier details.
- **Inventory Management:** Track medicine stock.
- **Patient Records:** Maintain patient records.
- **Order Processing:** Handle orders.
- **Employee Management:** Track employee details.

## Getting Started

### Prerequisites

- PostgreSQL

### Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/zgeybi/Pharmacy-Management-System.git
    ```
2. Navigate to the project directory:
    ```sh
    cd Pharmacy-Management-System
    ```
3. Execute the SQL schema to set up the database:
    ```sh
    psql -U yourusername -d yourdatabase -f schema_implementation.sql
    ```

## Usage

1. Ensure PostgreSQL is running and the database is set up with the provided schema.
2. Integrate the database with your application using appropriate PostgreSQL drivers and connection strings.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## License

This project is licensed under the MIT License.
