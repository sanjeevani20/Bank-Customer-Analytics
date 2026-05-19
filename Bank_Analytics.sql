CREATE DATABASE bank_analytics;
USE bank_analytics;

CREATE TABLE finance_1 (
    id INT,
    member_id INT,
    loan_amnt INT,
    funded_amnt INT,
    funded_amnt_inv DECIMAL(15,5),
    term INT,
    int_rate DECIMAL(10,5),
    installment DECIMAL(10,2),
    grade VARCHAR(5),
    sub_grade VARCHAR(5),
    emp_title VARCHAR(255),
    emp_length VARCHAR(50),
    home_ownership VARCHAR(50),
    annual_inc DECIMAL(15,2),
    verification_status VARCHAR(50),
    issue_d DATE,
    loan_status VARCHAR(50),
    pymnt_plan VARCHAR(5),
    purpose VARCHAR(100),
    title VARCHAR(255),
    zip_code VARCHAR(10),
    addr_state VARCHAR(10),
    dti DECIMAL(10,2),
    Year INT,
    Month VARCHAR(20)
);


SHOW VARIABLES LIKE "secure_file_priv";

-- IMPORT FINANCE_1 CSV
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/finance_1.csv'
INTO TABLE finance_1
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


CREATE TABLE finance_2 (
    id INT,
    delinq_2yrs INT,
    earliest_cr_line DATE,
    inq_last_6mths INT,
    mths_since_last_delinq VARCHAR(50),
    mths_since_last_record VARCHAR(50),
    open_acc INT,
    pub_rec INT,
    revol_bal BIGINT,
    revol_util VARCHAR(20),
    total_acc INT,
    initial_list_status VARCHAR(5),
    out_prncp DECIMAL(15,2),
    out_prncp_inv DECIMAL(15,2),
    total_pymnt DECIMAL(15,5),
    total_pymnt_inv DECIMAL(15,5),
    total_rec_prncp DECIMAL(15,5),
    total_rec_int DECIMAL(15,5),
    total_rec_late_fee DECIMAL(15,2),
    recoveries DECIMAL(15,2),
    collection_recovery_fee DECIMAL(15,2),
    last_pymnt_d VARCHAR(20),
    last_pymnt_amnt DECIMAL(15,2),
    last_credit_pull_d VARCHAR(20)
);

-- IMPORT FINANCE_2 CSV

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/finance_2.csv'
INTO TABLE finance_2
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- VERIFY IMPORTED DATA

SELECT COUNT(*) AS Finance1_Total_Rows FROM finance_1;

SELECT COUNT(*) AS Finance2_Total_Rows FROM finance_2;

-- QUERY 1 : TOTAL LOAN APPLICATIONS

SELECT 
    COUNT(id) AS Total_Loan_Applications
FROM finance_1;

-- QUERY 2 : TOTAL FUNDED AMOUNT

SELECT 
    SUM(loan_amnt) AS Total_Funded_Amount
FROM finance_1;

-- QUERY 3 : TOTAL AMOUNT RECEIVED

SELECT 
    ROUND(SUM(total_pymnt),2) AS Total_Amount_Received
FROM finance_2;

-- QUERY 4 : AVERAGE INTEREST RATE

SELECT 
    ROUND(AVG(int_rate),2) AS Average_Interest_Rate
FROM finance_1;

-- QUERY 5 : LOAN STATUS ANALYSIS

SELECT 
    loan_status,
    COUNT(*) AS Total_Loans
FROM finance_1
GROUP BY loan_status
ORDER BY Total_Loans DESC;

-- QUERY 6 : STATE WISE LOAN ANALYSIS

SELECT 
    addr_state,
    COUNT(id) AS Total_Loans,
    SUM(loan_amnt) AS Total_Loan_Amount
FROM finance_1
GROUP BY addr_state
ORDER BY Total_Loan_Amount DESC;

-- QUERY 7 : LOAN CATEGORY ANALYSIS

SELECT 
    purpose,
    COUNT(*) AS Total_Loans,
    SUM(loan_amnt) AS Total_Loan_Amount
FROM finance_1
GROUP BY purpose
ORDER BY Total_Loan_Amount DESC;

-- QUERY 8 : GOOD LOAN VS BAD LOAN ANALYSIS

SELECT 
    loan_status,
    COUNT(*) AS Total_Loans,
    SUM(loan_amnt) AS Total_Amount
FROM finance_1
WHERE loan_status IN ('Fully Paid', 'Charged Off')
GROUP BY loan_status;

-- QUERY 9 : JOIN ANALYSIS

SELECT 
    f1.id AS Customer_ID,
    f1.loan_amnt AS Loan_Amount,
    f1.grade AS Loan_Grade,
    f1.loan_status AS Loan_Status,
    f2.total_pymnt AS Total_Payment,
    f2.recoveries AS Recoveries
FROM finance_1 f1
JOIN finance_2 f2
ON f1.id = f2.id;

-- QUERY 10 : TOP 10 HIGHEST LOANS
SELECT 
    id,
    loan_amnt,
    grade,
    annual_inc
FROM finance_1
ORDER BY loan_amnt DESC
LIMIT 10;
