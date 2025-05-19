#  Investments and Savings Audit
---

[![Linux](https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black)](#)
[![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?logo=visual-studio-code&logoColor=white)](#)
[![GitHub](https://img.shields.io/badge/GitHub-%23121011.svg?logo=github&logoColor=white)](#)
[![Git](https://img.shields.io/badge/Git-F05032?logo=git&logoColor=white)](#)
[![MySQL](https://img.shields.io/badge/MySQL-4479A1?logo=mysql&logoColor=white)](#)
[![phpMyAdmin](https://img.shields.io/badge/phpMyAdmin-6C78AF?logo=phpmyadmin&logoColor=white)](#)
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)](#)
![Awesome](https://img.shields.io/badge/Awesome-ffd700?logo=awesome&logoColor=black)

---
This assessment is about using sql queries to derive business insights from customer data on investement and savings

It uses **MySQL** running inside **Docker Compose**, includes a setup SQL script, and provides a query to derive some insights.

## ⚙️ Setup

You can modify the following `docker-compose.yml`:

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8
    container_name: my-mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: mysecret
      MYSQL_DATABASE: adashi_database
    ports:
      - "3307:3306"
    volumes:
      - ./adashi_assessment.sql:/docker-entrypoint-initdb.d/adashi_assessment.sql

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    environment:
      PMA_HOST: mysql
    ports:
      - "8080:80"
```

Change:

- `MYSQL_ROOT_PASSWORD` to secure your DB
- `MYSQL_DATABASE` to create a different schema
- `adashi_assessment.sql` to you database creation file

---


### 🚀 Running the Containers
First make sure your sql script `adashi_assessment.sql` is executable

```bash
chmod 644 ./adashi_assessment.sql
```

```bash
docker-compose up -d
```

This will:

- Start a **MySQL 8** container (`my-mysql`)
- Create a database named `adashi_database`
- Load any SQL setup from `adashi_assessment.sql`
- Launch **phpMyAdmin** at `http://localhost:8080`

---


### 🔐 Access phpMyAdmin

Go to [http://localhost:8080](http://localhost:8080) and log in with:

- **Server**: `mysql`
- **Username**: `root`
- **Password**: `mysecret`

---


## 🧹 Stopping & Cleaning Up

To stop containers:

```bash
docker-compose down
```

To stop and remove volumes (⚠️ deletes data):

```bash
docker-compose down -v
```

Start MySQL and phpMyAdmin with:





---

## 📁 Project Structure

```
.
│
├── Assessment_Q1.sql
├── Assessment_Q2.sql
├── Assessment_Q3.sql
├── Assessment_Q4.sql
│
└── README.md

```
## 📊 Problem-Solving Approaches

### 1. Customers With Both Savings and Investment Plans

**Goal**: Identify customers who have at least one savings plan and one investment plan, and compute total deposits.

**Approach**:
- Join `users_customuser`, `plans_plan`, and `savings_savingsaccount`.
- Use `INNER JOIN` to avoid uneccesary computation on user with no plans and savings
- Use  `DISTINCT CASE ` to avoid counting a plan multiple times due to the join with savings_savingsaccount.

---

### 2. Inactive Plans (No Transactions for Over 365 Days)

**Goal**: Identify savings or investment plans that have not received inflows in the past year.

**Approach**:
The main thing here is the period to consider. But since we are looking for frequent vs. occasional users, it make more sense to look at the period from when they joined till the current date.
- We use `GREATEST` to avoid division by 0 for user that join less than 1 month ago.
- We use  Common Table Expression (CTE) to avoid calling  `GREATEST(TIMESTAMPDIFF(MONTH, U.date_joined, NOW())` many time
- `COUNT(customer_id) ` to avoid countin null values
---

### 3.accounts with no inflow transactions for over one year.
**Approach**:
- Here we are considering the plan , investement or saving as an account and we want information about the one active with no transaction. However there is no field that explicitely indicate that these plans are active or not. So we dcide to implicitely consider plan with no transaction for at least one year as unactive

- We return null value for last_transaction_date to incate plan with no transaction since they started. 
- We remove row whith null values for `is_a_fund` and `is_regular_savings`.
---

---

### 4. Estimate Customer Lifetime Value (CLV)

**Approach**:
- Since we are operating per month, we drop  user who signup less than one month ago to avoid division by zero
- We also only include valid transaction and avoid making computation with null values
- We return user with no transaction too
  

---

---

## 📝 Notes

- `adashi_assessment.sql` runs **only once**, when the container is first created. To re-run it:
  - Remove the volume (`-v`)
  - Restart the container
- Make sure your `adashi_assessment.sql` script creates:
  - `users_customuser`
  - `plans_plan`
  - `savings_savingsaccount`
  - `withdrawals_withdrawal`
- These queries are designed to work for MySQL. They may not work for other database like  PostgreSQL.
  
---
## Technical issues
When I start the containers, no tables was showing. The first thing I do is to look at the log files of my containers using the commands:

```bash
 Docker logs `container id`
```

Then I realize there an error in mysql container because the script `adashi_assessment.sql` is not executable. I make it executable using the command:

```bash
 chmod 644 adashi_assessment.sql
```
Then I rerun the containers and it worked.
## 🛠️ Author

Built by **Koomi Toussaint AMOUSSOUVI**

Data Scientist

