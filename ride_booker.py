# importing required libraries
import mysql.connector
import datetime
import time

con = mysql.connector.connect(
  host ="localhost",
  port =3306,
  user ="root",
  passwd ="",
  database = "cab_sharing_system"
)
# preparing a cursor object
cursorObject = con.cursor()



while(True):
    time_now = datetime.datetime.now()
    date_now = time_now.date()
    sub_time = time_now + datetime.timedelta(minutes = 22, seconds = 30)
    add_time = time_now + datetime.timedelta(minutes = 37, seconds = 30)
    ride_time = time_now + datetime.timedelta(minutes = 30)
    args = (date_now, ride_time, sub_time, add_time)
    cursorObject.callproc('book_rides', args)
    con.commit()
    print("Updated at " + str(time_now))
    time.sleep(900)

# Disconnecting from the server
con.close()
