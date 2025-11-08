CREATE ROLE IF NOT EXISTS r_db_admin;
CREATE ROLE IF NOT EXISTS r_db_worker;
CREATE ROLE IF NOT EXISTS r_data_broker;
CREATE ROLE IF NOT EXISTS r_user_role;
CREATE ROLE IF NOT EXISTS r_business_role;

-- Admin: All permission
GRANT ALL PRIVILEGES ON UABS.* TO r_db_admin;

-- Worker: no CREATE/DROP/ALTER privileges
GRANT SELECT, INSERT, UPDATE, DELETE ON UABS.* TO r_db_worker;

-- User: see their portal view, can create/manage appointments only
GRANT SELECT ON UABS.v_user_portal TO r_user_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON UABS.Appointment TO r_user_role;

-- Business: see business portal view, can manage their services and appointments
GRANT SELECT ON UABS.v_business_portal TO r_business_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON UABS.Service TO r_business_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON UABS.Appointment TO r_business_role;

-- Data broker: read only using the broker view and can see business summary table
GRANT SELECT ON UABS.v_databroker_portal TO r_data_broker;
GRANT SELECT ON UABS.Buisness_Report TO r_data_broker;

-- Grant message read/compose to users & businesses
GRANT SELECT, INSERT ON UABS.Message TO r_user_role, r_business_role;
