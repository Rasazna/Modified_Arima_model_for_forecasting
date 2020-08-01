\t
\a
\f ,
\o /var/www/html/hcdashboard/bin/prediction/headcount_prediction_employees.csv
select count(*),month,year from headcount_archive where ((year = '2017' OR  year = '2018' OR year = '2019') AND (jd !~ 'Intern') AND (employeetype = 'Employee') AND (l1name ='Anand S. Athreya')) group by month,year;
\o /var/www/html/hcdashboard/bin/prediction/headcount_prediction_contractors.csv
select count(*),month,year from headcount_archive where ((year = '2017' OR  year = '2018' OR year = '2019') AND (jd !~ 'Intern') AND (employeetype = 'Non Employee') AND (l1name ='Anand S. Athreya')) group by month,year;
\o /var/www/html/hcdashboard/bin/prediction/termination_prediction_employees.csv
select count(*),term_month,term_year from termination where ((term_year >'2016') AND (org = 'EMP') AND (voluntary = 'Voluntary') AND (hierarchy ~ 'asathreya')  AND ((job_description!~'Intern') AND (job_description !~ 'Agency') AND (job_description !~ 'Outsource'))) group by term_year,term_month;
\o /var/www/html/hcdashboard/bin/prediction/termination_prediction_contractors.csv
select count(*),term_month,term_year from termination where ((term_year >'2016') AND (org = 'POI') AND (voluntary = 'Voluntary')   AND (hierarchy ~ 'asathreya') AND (job_description!~'Intern')) group by term_year,term_month;
\o /var/www/html/hcdashboard/bin/prediction/newhire_prediction_contractors.csv
select count(*),hire_month,hire_year from newhire where ((hire_year >'2016') AND (hierarchy ~ 'asathreya') AND (org = 'POI') AND (job_description!~'Intern')) group by hire_year,hire_month;
\o /var/www/html/hcdashboard/bin/prediction/newhire_prediction_employees.csv
select count(*),hire_month,hire_year from newhire where ((hire_year >'2016') AND (org = 'EMP') AND (hierarchy ~ 'asathreya') AND (job_description!~'Intern') AND (job_description !~ 'Agency') AND  (job_description !~ 'Outsource')) group by hire_year,hire_month