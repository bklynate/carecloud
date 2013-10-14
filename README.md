Appointment Service APIs
=========
  **Create Appointment**
  ----
    Create an appointment with new data.

  * **URL**

    /api/appointments

  * **Method:**

    `POST`

  *  **URL Params**

     **Required:**
     start_time=[datetime]
     end_time=[datetime]
     first_name=[string]
     last_name=[string]
     comments=[text]
  * **Data Params**

    None

  * **Success Response:**

    * **Code:** 201 <br />
      **Content:** `{
                        "appointment": {
                            "comments": "",
                            "created_at": "2013-10-13T02:23:07Z",
                            "end_time": "2013-12-09T10:30:00Z",
                            "first_name": "jason",
                            "id": 168,
                            "last_name": "jiang",
                            "start_time": "2013-12-09T09:30:00Z",
                            "updated_at": "2013-10-14T22:08:54Z"
                        }
                    }`

  * **Error Response:**

    * **Code:** 422 Unprocessable Entity <br />
      **Content:** `{ error : {"start_time":['can't be blank','has already been taken','appointment time must start in future']} }`

  * **Sample Call:**

    ```javascript
      $.ajax({
        url: "/api/appointments",
        dataType: "json",
        type : "POST",
        success : function(r) {
          console.log(r);
        }
      });
   ```


  **List Appointments**
  ----
    Returns json data about all valid appointments,sorted by given criteria(default by "start_time") and grouped by date.

  * **URL**

    /api/appointments(/start_time(/end_time))

  * **Method:**

    `GET`

  *  **URL Params**

     **Required:**

     `none`
     **Optional:**
     start_time=[datetime]
     end_time=[datetime]

  * **Data Params**

    None

  * **Success Response:**

    * **Code:** 200 <br />
      **Content:** `{
                     total_appointments: 168,
                     valid_appointments: 62,
                     total_appointments_dates: 8,
                     start_time: "2011-01-13T07:00:00Z",
                     end_time: "2011-12-13T15:10:00Z",
                     sort_by: "start_time",
                     appointments: [
                     {
                     date: "2011-01-13",
                     number_of_overlapped_appointments: 1,
                     number_of_appointments: 4,
                     items: []
                     },
                     {
                     date: "2011-04-13",
                     number_of_appointments: 4,
                     items: [
                     {
                     start_time: "2011-04-13T09:00:00Z",
                     end_time: "2011-04-13T09:10:00Z",
                     first_name: "dawn",
                     last_name: "robins"
                     },
                     {
                     start_time: "2011-04-13T13:15:00Z",
                     end_time: "2011-04-13T13:20:00Z",
                     first_name: "barbara",
                     last_name: "briggs"
                     },
                     {
                     start_time: "2011-04-13T15:00:00Z",
                     end_time: "2011-04-13T15:05:00Z",
                     first_name: "tatiana",
                     last_name: "aragon"
                     },
                     {
                     start_time: "2011-04-13T16:30:00Z",
                     end_time: "2011-04-13T16:35:00Z",
                     first_name: "john",
                     last_name: "doe"
                     }
                     ]
                     }]}`

  * **Error Response:**

    * **Code:** 400 Bad Request <br />
      **Content:** `{ error : "start_time and end_time are invalid." }`
  * **Sample Call:**

    ```javascript
      $.ajax({
        url: "/api/appointments/201101040730/2011081030",
        dataType: "json",
        type : "GET",
        success : function(r) {
          console.log(r);
        }
      });
    ```

  **Update Appointment**
  ----
    Update an appointment with new data.

  * **URL**

    /api/appointments/:id

  * **Method:**

    `PUT`

  *  **URL Params**

     **Required:**
       id=[integer]

     **Optional:**
     start_time=[datetime]
     end_time=[datetime]
     first_name=[string]
     last_name=[string]
     comments=[text]
  * **Data Params**

    None

  * **Success Response:**

    * **Code:** 202 <br />
      **Content:** `{
                        "appointment": {
                            "comments": "",
                            "created_at": "2013-10-13T02:23:07Z",
                            "end_time": "2013-12-09T10:30:00Z",
                            "first_name": "jason",
                            "id": 168,
                            "last_name": "jiang",
                            "start_time": "2013-12-09T09:30:00Z",
                            "updated_at": "2013-10-14T22:08:54Z"
                        }
                    }`

  * **Error Response:**

    * **Code:** 422 Unprocessable Entity <br />
      **Content:** `{ error : {"start_time":['can't be blank','has already been taken','appointment time must start in future']} }`

  * **Sample Call:**

    ```javascript
      $.ajax({
        url: "/api/appointments/168",
        dataType: "json",
        type : "PUT",
        success : function(r) {
          console.log(r);
        }
      });

    ```
   **Delete Appointment**
        ----
          Delete an appointment.

        * **URL**

          /api/appointments/:id

        * **Method:**

          `DELETE`

        *  **URL Params**

           **Required:**
           id=[integer]
        * **Data Params**

          None

        * **Success Response:**

          * **Code:** 201 <br />
            **Content:** `{
                             {"message" => "The appointment of Jason Jiang at 2013-10-13T02:23:07Z has been successfully deleted."}
                          }`

        * **Error Response:**

          * **Code:** 422 Unprocessable Entity <br />
            **Content:** `{ error : "This appointment you are trying to delete doesn't exist" }`

            **Code:** 400 Bad Request <br />
            **Content:** `{ error : "No appointment has been specified" }`


        * **Sample Call:**

          ```javascript
            $.ajax({
              url: "/api/appointments/168",
              dataType: "json",
              type : "delete",
              success : function(r) {
                console.log(r);
              }
            });
          ```
