# Analytics Engineer Project - Adventure Works
![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![Snowflake](https://img.shields.io/badge/snowflake-%2329B5E8.svg?style=for-the-badge&logo=snowflake&logoColor=white)
![Power Bi](https://img.shields.io/badge/power_bi-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Figma](https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white)

<div align="center">
  <figure>
    <img
      src="images\print_dashboard_home_page.png"
      title="BI Sales - Adventure Works"
      alt="BI Sales - Adventure Works"
      width="1200">
    <figcaption>
      <a href="https://app.powerbi.com/view?r=eyJrIjoiY2U4ZTkzN2QtN2RlNy00ZTlhLTgyMzMtMDliODQzM2I1Yjk0IiwidCI6ImJlZjFjNzg0LTVjN2QtNDBhNC05NzkwLWVlYmQ0OGYyZDg2MyJ9">
        Visit the project's BI dashboard
      </a>
    </figcaption>
  </figure>
</div>

<br>

* [About The Project](#about-the-project)
* [Data Sources](#data-sources)
* [Data Warehouse](#data-warehouse)
* [BI Dashboard](#bi-dashboard)
* [License](#license)

## About The Project

This project was developed as a solution for the [**Analytics Engineer Certification challenge from Indicium**](https://academy.indicium.tech/course/certificao-em-engenharia-de-analytics-by-indicium). The objective was to build a **data warehouse** and a dashboard for the sales area of Adventure Works, a bicycle manufacturer, following **Modern Data Stack** project practices. The project used the **ELT** approach, in which the raw data extracted and loaded into a "raw" schema in **Snowflake** was transformed in **dbt**, creating a dimensional model after the "staging", "intermediate" and "marts" layers. After the last layer, the **data warehouse** was finalized, with the fact and dimension tables created in the **data warehouse** schema in **Snowflake**. Finally, **Power BI** was connected to the **data warehouse** for the development of the sales area dashboard, meeting the business needs of Adventure Works.

## Data Sources

The project used public data from the Adventure Works transactional database, which contains 68 tables distributed across 5 schemas: HR, Sales, Production, and Purchasing. The complete database diagram can be viewed below.

<div align="center">
  <img
    src="images\database_adventure_works.jpeg"
    title="Adventure Works database entity relationship diagram"
    alt="Adventure Works database entity relationship diagram"
    width="600">
</div>

<br>

All tables in the database were previously loaded into a "raw" schema in **Snowflake**, the platform used to host the **data warehouse** in the cloud.

To develop a project using Adventure Works data, the data can be obtained from the GitHub repository: https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/adventure-works.

## Data Warehouse

The **data warehouse** was built following the [entity-relationship diagram](erd_adventure_works.pdf) developed for this project, based on a Star Schema. Five dimensions were created: "dim_customers," "dim_products," "dim_sellers," "dim_address," and "dim_dates," and one fact table: "fact_orders_details."

To transform the data and create the **data warehouse**, **dbt** was used in conjunction with **Snowflake**. The data went through three transformation layers: "staging," "intermediate," and "marts."

Initially, the necessary tables with the raw data were cleaned in the "staging" layer. Then, they were transformed in the "intermediate" layer, where the dimensions were consolidated, and the business metrics of the fact table were created. Finally, in the "marts" layer, the dimension and fact tables were created, according to the **data warehouse** diagram. All layers and models developed can be found in the [**"models"**](models) folder of this repository.

Additionally, documentation was created for the models in the .yml files, and generic and singular tests were applied.

## BI Dashboard

The interactive dashboard was developed in **Power BI**, connected to the **data warehouse** in **Snowflake**. The page design was created in **Figma**, and the data visualizations were designed to meet the business needs of the Adventure Works sales area, as specified in the certification challenge.

The complete dashboard can be viewed by [**clicking here**](https://app.powerbi.com/view?r=eyJrIjoiY2U4ZTkzN2QtN2RlNy00ZTlhLTgyMzMtMDliODQzM2I1Yjk0IiwidCI6ImJlZjFjNzg0LTVjN2QtNDBhNC05NzkwLWVlYmQ0OGYyZDg2MyJ9).

<div align="center">
  <p>
    <img
      src="images\print_dashboard_home_page.png"
      title="BI Sales - Home page"
      alt="BI Sales - Home page"
      width="450"
      hspace="10">
    <img
      src="images\print_dashboard_product_page.png"
      title="BI Sales - Product page"
      alt="BI Sales - Product page"
      width="450"
      hspace="10">
  </p>
  <p>
    <img
      src="images\print_dashboard_seller_page.png"
      title="BI Sales - Seller page"
      alt="BI Sales - Seller page"
      width="450"
      hspace="10">
    <img
      src="images\print_dashboard_location_page.png"
      title="BI Sales - Location page"
      alt="BI Sales - Location page"
      width="450"
      hspace="10">
  </p>
</div>

## License

This project is under MIT License, see the [LICENSE.txt](LICENSE.txt) file for more details.