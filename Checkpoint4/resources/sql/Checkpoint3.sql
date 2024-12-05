

-- Query 1.1: List the rooms that are occupied, along with the associated patient names and the date the patient was admitted
SELECT R.Room_Num,
       A.Admission_Date,
       CONCAT(P.First_Name, ' ', P.Last_Name) AS Patient_Name
FROM Room R
JOIN Patient P  ON R.Room_Num = P.Room_Num
JOIN  Admission A ON A.Patient_ID = P.Patient_ID
WHERE R.Is_Occupied = TRUE;



-- Query 1.2: List the rooms that are currently unoccupied */
SELECT Room_Num
FROM Room
WHERE Is_Occupied = FALSE;


-- Query 1.3: List all rooms in the hospital along with patient names and admission dates for those that are occupied
SELECT R.Room_Num,
    CONCAT(P.First_Name, ' ', P.Last_Name) AS Patient_Name,
    A.Admission_Date
FROM Room R
JOIN Patient P ON R.Room_Num = P.Room_Num
JOIN Admission A ON P.Patient_ID = A.Patient_ID
WHERE R.Is_Occupied = TRUE; 


-- Query 2.1: List all patients in the database with FULL personal information
SELECT *
FROM Patient;


-- Query 2.2: List all patients currently admitted to the hospital. List only patient identification number and name.
SELECT P.Patient_ID,
    CONCAT(P.First_Name, ' ', P.Last_Name) AS Patient_Name
FROM Patient P
JOIN Admission A ON P.Patient_ID = A.Patient_ID
WHERE A.Discharge_Date IS NULL;



-- Query 2.3: List all patients who were discharged in a given date range. List only patient identification number and name
    CONCAT(P.First_Name, ' ', P.Last_Name) AS Patient_Name
FROM Patient P
JOIN Admission A ON P.Patient_ID = A.Patient_ID
WHERE A.Admission_Date BETWEEN '2023-10-01' AND '2024-01-25';



-- Query 2.4: List all patients who were admitted within a given date range. List only patient identification number and name
SELECT P.Patient_ID, 
    CONCAT(P.First_Name, ' ', P.Last_Name) AS Patient_Name
FROM Patient P
JOIN Admission A ON P.Patient_ID = A.Patient_ID
WHERE A.Admission_Date BETWEEN '2023-10-01' AND '2024-01-25';



-- Query 2.5: For a given patient (either patient identification number or name),
SELECT A.Admission_ID,
    A.Diagnosis, 
    A.Admission_Date, 
    A.Discharge_Date
FROM Admission A
JOIN Patient P ON A.Patient_ID = P.Patient_ID
WHERE P.Patient_ID = 3 OR P.First_Name = '%John' OR P.Last_Name = '%Watts';

-- Query 2.6: For a given patient (either patient identification number or name), list all treatments that were administered. Group treatments by admissions.List admissions in descending chronological order, and list treatments in ascending chronological order within each admission
SELECT A.Admission_ID,
    A.Admission_Date,
    A.Diagnosis,
    T.Procedures,
    T.Medication, 
    T.Order_Timestamp
FROM Admission A 
JOIN Patient P ON P.Patient_ID = A.Patient_ID
JOIN Treatment T ON A.Patient_ID = T.Patient_ID
WHERE P.Patient_ID = 1 OR P.First_Name = '%Emily' OR  P.Last_Name = '%White'
ORDER BY A.Admission_Date DESC, T.Order_Timestamp ASC; 


-- Query 2.7: List patients who were admitted to the hospital within 30 days of their last discharge date. For each patient list their patient identification number, name, diagnosis, and admitting doctor.
SELECT P.Patient_ID, 
       CONCAT(P.First_Name, ' ', P.Last_Name) AS Patient_Name, 
       A1.Diagnosis,
       CONCAT(E.First_Name, ' ', E.Last_Name) AS Admitting_Doctor_Name
FROM Patient P
JOIN Admission A1 ON P.Patient_ID = A1.Patient_ID
JOIN Doctor_Patient_Assignment DPA ON A1.Admission_ID = DPA.Admission_ID
JOIN Doctor D ON DPA.Doctor_ID = D.Doctor_ID
JOIN Employee E ON D.Employee_ID = E.Employee_ID
JOIN Admission A2 ON A1.Patient_ID = A2.Patient_ID
                    AND A1.Admission_Date 
                    BETWEEN DATE_ADD(A2.Discharge_Date, INTERVAL 1 DAY)
                    AND DATE_ADD(A2.Discharge_Date, INTERVAL 30 DAY)
WHERE A2.Discharge_Date IS NOT NULL
ORDER BY P.Patient_ID, A1.Admission_Date;


-- Query 2.8: For each patient that has ever been admitted to the hospital, list their total number of admissions, average duration of each admission, longest span between admissions, shortest span between admissions, and average span between admissions.
SELECT P.Patient_ID,
    CONCAT(P.First_Name, ' ', P.Last_Name) AS Patient_Name,
    COUNT(A.Admission_ID) AS Total_Num_Admissions, 
    AVG(DATEDIFF(A.Discharge_Date, A.Admission_Date)) AS Avg_Admin_Duration, 
    MAX(DATEDIFF(Follow_Up.Discharge_Date, A.Admission_Date)) AS Max_Admin_Duration,
    MIN(DATEDIFF(Follow_Up.Discharge_Date, A.Admission_Date)) AS Min_Admin_Duration,
    AVG(DATEDIFF(Follow_Up.Discharge_Date, A.Admission_Date)) AS Avg_Time_Between
FROM Patient P 
JOIN Admission A ON P.Patient_ID = A.Patient_ID
LEFT JOIN Admission FOLLOW_UP 
    ON FOLLOW_UP.Patient_ID = A.Patient_ID 
    AND FOLLOW_UP.Admission_Date > A.Discharge_Date
GROUP BY P.Patient_ID, Patient_Name;


-- Query 3.1: List the diagnoses given to patients, in descending order of occurrences. List diagnosis identification number, name, and total occurrences of each diagnosis.
SELECT A.Diagnosis_ID,
    A.Diagnosis,
    COUNT(*) as Total_Num_Diagnoses_Occurrences
FROM Admission A 
GROUP BY A.Diagnosis, A.Diagnosis_ID
ORDER BY Total_Num_Diagnoses_Occurrences DESC; 


-- Query 3.2: List the diagnoses given to hospital patients, in descending order of occurrences. List diagnosis identification number, name, and total occurrences of each diagnosis.
SELECT A.Diagnosis_ID, 
    A.Diagnosis,
    COUNT(*) AS Total_Num_Diagnoses_Occurrences
FROM Admission A 
JOIN Patient P ON A.Patient_ID = P.Patient_ID
WHERE A.Discharge_Date IS NULL
GROUP BY A.Diagnosis_ID, A.Diagnosis
ORDER BY Total_Num_Diagnoses_Occurrences DESC; 


-- Query 3.3: List the treatments performed on admitted patients, in descending order of occurrences. List treatment identification number, name, and total number of occurrences of each treatment. */
SELECT T.Treatment_ID, 
    T.Procedures,
    COUNT(*) AS Total_Num_Treatment_Occurrences
FROM Treatment T
GROUP BY T.Treatment_ID, T.Procedures
ORDER BY Total_Num_Treatment_Occurrences DESC;


-- Query 3.4: List the diagnoses associated with patients who have the highest occurrences of admissions to the hospital, in ascending order or correlation. */
SELECT A.Diagnosis,
       COUNT(*) AS Total_Occurrences
FROM Admission A
JOIN (
    SELECT Patient_ID
    FROM Admission
    GROUP BY Patient_ID
    HAVING COUNT(*) = (
        SELECT MAX(Admission_Count)
        FROM (SELECT COUNT(*) AS Admission_Count
            FROM Admission
            GROUP BY Patient_ID) AS PatientAdmissions)) AS MostAdmittedPatients ON A.Patient_ID = MostAdmittedPatients.Patient_ID
GROUP BY A.Diagnosis
ORDER BY Total_Occurrences ASC;


-- Query 3.5: For a given treatment occurrence, list the patient name and the doctor who ordered the treatment.
SELECT T.Procedures, 
    CONCAT(P.First_Name, ' ', P.Last_Name) as Patient_Name,
    CONCAT(E.First_Name, ' ', E.Last_Name) as Doctor_Name 
FROM Treatment T
JOIN Patient P ON T.Patient_ID = P.Patient_ID
JOIN Doctor D ON T.Doctor_ID = D.Doctor_ID
JOIN Employee E ON D.Employee_ID = E.Employee_ID
WHERE T.Procedures = 'X-ray';


-- Query 4.1: List all workers at the hospital, in ascending last name, first name order. For each worker, list their name, and job category. */
SELECT E.First_Name AS First_Name,
    E.Last_Name AS Last_Name,
    E.Role 
FROM Employee E
ORDER BY Last_Name ASC, First_Name ASC;

-- Query 4.2: List the primary doctors of patients with a high admission rate (at least 4 admissions within a one-year time frame). */
SELECT 
    CONCAT(E.First_Name, ' ', E.Last_Name) AS Primary_Doctor_Name,
    CONCAT(P.First_Name, ' ', P.Last_Name) AS Patient_Name,
    COUNT(A.Admission_ID) AS Total_Admissions,
    YEAR(A.Admission_Date) AS Admission_Year
FROM Admission A
JOIN Patient P ON A.Patient_ID = P.Patient_ID
JOIN Doctor D ON P.Primary_Dr = D.Doctor_ID
JOIN Employee E ON D.Employee_ID = E.Employee_ID
WHERE A.Admission_Date BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 YEAR) AND CURDATE()
GROUP BY P.Patient_ID, Primary_Doctor_Name, Admission_Year
HAVING COUNT(A.Admission_ID) >= 4
ORDER BY Total_Admissions DESC, Admission_Year DESC;


-- Query 4.3: For a given doctor, list all associated diagnoses in descending order of occurrence. For each diagnosis, list the total number of occurrences for the given doctor. */
SELECT 
    CONCAT(E.First_Name, ' ', E.Last_Name),
    A.Diagnosis AS Diagnosis_Name,
    COUNT(A.Diagnosis) AS Diagnosis_Occurrences
FROM Admission A
JOIN Patient P ON A.Patient_ID = P.Patient_ID
JOIN Doctor D ON P.Primary_Dr = D.Doctor_ID
JOIN Employee E On D.Employee_ID = E.Employee_ID
WHERE D.Doctor_ID = 1 
GROUP BY A.Diagnosis
ORDER BY Diagnosis_Occurrences DESC;

--Query 4.4: For a given doctor, list all treatments that they ordered in descending order of occurrence. For each treatment, list the total number of occurrences for the given doctor. */
SELECT 
    T.Procedures AS Treatment_Name,
    COUNT(T.Treatment_ID) AS Treatment_Occurrences
FROM Treatment T
JOIN Doctor D ON T.Doctor_ID = D.Doctor_ID
WHERE D.Doctor_ID = 1 
GROUP BY T.Procedures
ORDER BY Treatment_Occurrences DESC;

-- Query 4.5: List employees who have been involved in the treatment of every admitted patient. */
SELECT 
    E.Employee_ID,
    CONCAT(E.First_Name, ' ', E.Last_Name) AS Employee_Name,
    E.Role,
    COUNT(DISTINCT T.Patient_ID) AS Patients_Treated
FROM 
    Employee E
LEFT JOIN 
    Treatment T ON T.Doctor_ID = E.Employee_ID 
                OR T.Nurse_ID = E.Employee_ID 
                OR T.Tech_ID = E.Employee_ID
GROUP BY 
    E.Employee_ID
ORDER BY 
    Patients_Treated DESC;










