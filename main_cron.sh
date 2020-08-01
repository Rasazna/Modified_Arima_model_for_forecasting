export PGPASSWORD=postgres
/usr/bin/psql -U postgres hrdata -f prediction.sql
python3 append_header.py
Rscript headcount_prediction.r
Rscript headcount_prediction_contractors.r
Rscript newhire_prediction.r
Rscript newhire_prediction_contractors.r 
Rscript termination_prediction_contractors.r 
Rscript termination_prediction.r 

