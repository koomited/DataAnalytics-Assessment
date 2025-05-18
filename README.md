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

This project helps identify **inactive savings or investment accounts** by checking for the absence of **confirmed inflow transactions** over the past year.

It uses **MySQL** running inside **Docker Compose**, includes a setup SQL script (`init.sql`), and provides a query to detect inactive accounts.

## ⚙️ Setup

You can modify `docker-compose.yml`:

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8
    container_name: my-mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: mysecret
      MYSQL_DATABASE: adashi_staging
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


```bash
docker-compose up -d
```

This will:

- Start a **MySQL 8** container (`my-mysql`)
- Create a database named `adashi_staging`
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
---

## 🛠️ Author

Built by [Your Name]  
SQL & Data Engineering with Docker

