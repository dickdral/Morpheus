--------------------------------------------------------
--  File created - donderdag-september-14-2017   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Sequence LBM_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "LBM_SEQ";
--------------------------------------------------------
--  DDL for Table LBM_LOCATION_BEACONS
--------------------------------------------------------

  CREATE TABLE "LBM_LOCATION_BEACONS" 
   (	"LBE_ID" NUMBER, 
	"LBE_UUI_ID" VARCHAR2(200 BYTE), 
	"LBE_LOC_ID" NUMBER, 
	"LBE_MAJOR_ID" NUMBER, 
	"LBE_MINOR_ID" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table LBM_LOCATIONS
--------------------------------------------------------

  CREATE TABLE "LBM_LOCATIONS" 
   (	"LOC_ID" NUMBER, 
	"LOC_NAME" VARCHAR2(100 BYTE), 
	"LOC_COLOR" VARCHAR2(20 BYTE), 
	"LOC_ICON" VARCHAR2(100 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table LBM_LOC_MENU_OPTIONS
--------------------------------------------------------

  CREATE TABLE "LBM_LOC_MENU_OPTIONS" 
   (	"LMO_ID" NUMBER, 
	"LMO_USR_ID" NUMBER, 
	"LMO_LOC_ID" NUMBER, 
	"LMO_MEN_ID" NUMBER, 
	"LMO_SEQNO" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table LBM_MENU_OPTIONS
--------------------------------------------------------

  CREATE TABLE "LBM_MENU_OPTIONS" 
   (	"MEN_ID" NUMBER, 
	"MEN_NAME" VARCHAR2(100 BYTE), 
	"MEN_URL" VARCHAR2(4000 BYTE), 
	"MEN_ICON" VARCHAR2(100 BYTE), 
	"MEN_IMAGE" VARCHAR2(1000 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table LBM_USERS
--------------------------------------------------------

  CREATE TABLE "LBM_USERS" 
   (	"USR_ID" NUMBER, 
	"USR_USERNAME" VARCHAR2(100 BYTE), 
	"USR_NAME" VARCHAR2(100 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for View LBM_LOC_MENU_OPTIONS_VW
--------------------------------------------------------

  CREATE OR REPLACE VIEW "LBM_LOC_MENU_OPTIONS_VW" ("LMO_ID", "LMO_USR_ID", "LMO_LOC_ID", "LMO_MEN_ID", "LMO_SEQNO", "MEN_ID", "MEN_NAME", "MEN_URL", "MEN_ICON", "MEN_IMAGE") AS 
  select "LMO_ID","LMO_USR_ID","LMO_LOC_ID","LMO_MEN_ID","LMO_SEQNO","MEN_ID","MEN_NAME","MEN_URL","MEN_ICON","MEN_IMAGE"
from   lbm_loc_menu_options   lmo
  join lbm_menu_options       men
       on  men.men_id = lmo.lmo_men_id;
--------------------------------------------------------
--  Constraints for Table LBM_LOCATION_BEACONS
--------------------------------------------------------

  ALTER TABLE "LBM_LOCATION_BEACONS" ADD CONSTRAINT "LBM_LOCATION_BEACONS_PK" PRIMARY KEY ("LBE_ID") ENABLE;
  ALTER TABLE "LBM_LOCATION_BEACONS" MODIFY ("LBE_MAJOR_ID" NOT NULL ENABLE);
  ALTER TABLE "LBM_LOCATION_BEACONS" MODIFY ("LBE_LOC_ID" NOT NULL ENABLE);
  ALTER TABLE "LBM_LOCATION_BEACONS" MODIFY ("LBE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table LBM_LOCATIONS
--------------------------------------------------------

  ALTER TABLE "LBM_LOCATIONS" ADD CONSTRAINT "LBM_LOCATIONS_UK1" UNIQUE ("LOC_NAME") ENABLE;
  ALTER TABLE "LBM_LOCATIONS" ADD CONSTRAINT "LBM_LOCATIONS_PK" PRIMARY KEY ("LOC_ID") ENABLE;
  ALTER TABLE "LBM_LOCATIONS" MODIFY ("LOC_NAME" NOT NULL ENABLE);
  ALTER TABLE "LBM_LOCATIONS" MODIFY ("LOC_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table LBM_LOC_MENU_OPTIONS
--------------------------------------------------------

  ALTER TABLE "LBM_LOC_MENU_OPTIONS" ADD CONSTRAINT "LBM_LOC_MENU_OPTIONS_PK" PRIMARY KEY ("LMO_ID") ENABLE;
  ALTER TABLE "LBM_LOC_MENU_OPTIONS" MODIFY ("LMO_SEQNO" NOT NULL ENABLE);
  ALTER TABLE "LBM_LOC_MENU_OPTIONS" MODIFY ("LMO_MEN_ID" NOT NULL ENABLE);
  ALTER TABLE "LBM_LOC_MENU_OPTIONS" MODIFY ("LMO_LOC_ID" NOT NULL ENABLE);
  ALTER TABLE "LBM_LOC_MENU_OPTIONS" MODIFY ("LMO_USR_ID" NOT NULL ENABLE);
  ALTER TABLE "LBM_LOC_MENU_OPTIONS" MODIFY ("LMO_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table LBM_MENU_OPTIONS
--------------------------------------------------------

  ALTER TABLE "LBM_MENU_OPTIONS" ADD CONSTRAINT "LBM_MENU_OPTIONS_PK" PRIMARY KEY ("MEN_ID") ENABLE;
  ALTER TABLE "LBM_MENU_OPTIONS" MODIFY ("MEN_URL" NOT NULL ENABLE);
  ALTER TABLE "LBM_MENU_OPTIONS" MODIFY ("MEN_NAME" NOT NULL ENABLE);
  ALTER TABLE "LBM_MENU_OPTIONS" MODIFY ("MEN_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table LBM_USERS
--------------------------------------------------------

  ALTER TABLE "LBM_USERS" ADD CONSTRAINT "LBM_USERS_UK1" UNIQUE ("USR_USERNAME") ENABLE;
  ALTER TABLE "LBM_USERS" ADD CONSTRAINT "LBM_USERS_PK" PRIMARY KEY ("USR_ID") ENABLE;
  ALTER TABLE "LBM_USERS" MODIFY ("USR_USERNAME" NOT NULL ENABLE);
  ALTER TABLE "LBM_USERS" MODIFY ("USR_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table LBM_LOCATION_BEACONS
--------------------------------------------------------

  ALTER TABLE "LBM_LOCATION_BEACONS" ADD CONSTRAINT "LBM_LOCATION_BEACONS_FK1" FOREIGN KEY ("LBE_LOC_ID")
	  REFERENCES "LBM_LOCATIONS" ("LOC_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table LBM_LOC_MENU_OPTIONS
--------------------------------------------------------

  ALTER TABLE "LBM_LOC_MENU_OPTIONS" ADD CONSTRAINT "LBM_LOC_MENU_OPTIONS_FK1" FOREIGN KEY ("LMO_LOC_ID")
	  REFERENCES "LBM_LOCATIONS" ("LOC_ID") ENABLE;
  ALTER TABLE "LBM_LOC_MENU_OPTIONS" ADD CONSTRAINT "LBM_LOC_MENU_OPTIONS_FK2" FOREIGN KEY ("LMO_MEN_ID")
	  REFERENCES "LBM_MENU_OPTIONS" ("MEN_ID") ENABLE;
  ALTER TABLE "LBM_LOC_MENU_OPTIONS" ADD CONSTRAINT "LBM_LOC_MENU_OPTIONS_FK3" FOREIGN KEY ("LMO_USR_ID")
	  REFERENCES "LBM_USERS" ("USR_ID") ENABLE;
--------------------------------------------------------
--  DDL for Trigger LBM_LBE_BIU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "LBM_LBE_BIU" 
before insert or update on lbm_location_beacons
for each row
begin
  :new.lbe_id := coalesce(:new.lbe_id,lbm_seq.nextval);
end;
/
ALTER TRIGGER "LBM_LBE_BIU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger LBM_LMO_BIU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "LBM_LMO_BIU" 
before insert or update on lbm_loc_menu_options
for each row
begin
  :new.lmo_id := coalesce(:new.lmo_id,lbm_seq.nextval);
end;
/
ALTER TRIGGER "LBM_LMO_BIU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger LBM_LOC_BIU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "LBM_LOC_BIU" 
before insert on lbm_locations
for each row
begin
  :new.loc_id := coalesce(:new.loc_id,lbm_seq.nextval);
end;
/
ALTER TRIGGER "LBM_LOC_BIU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger LBM_MEN_BIU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "LBM_MEN_BIU" 
before insert or update on lbm_menu_options
for each row
begin
  :new.men_id := coalesce(:new.men_id,lbm_seq.nextval);
end;
/
ALTER TRIGGER "LBM_MEN_BIU" ENABLE;
--------------------------------------------------------
--  DDL for Trigger LBM_USR_BIU
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "LBM_USR_BIU" 
before insert or update on lbm_users
for each row
begin
  :new.usr_id := coalesce(:new.usr_id,lbm_seq.nextval);
end;
/
ALTER TRIGGER "LBM_USR_BIU" ENABLE;
--------------------------------------------------------
--  DDL for Package LBM_PCK
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "LBM_PCK" is

  function get_menu_items
      ( p_loc_id    in  number
      , p_usr_id    in  number
      ) return varchar2;
      
  procedure set_menu_items
      ( p_loc_id      in  number
      , p_usr_id      in  number
      , p_menu_items  in  varchar2
      );
  
  procedure set_to_location ( p_loc_id in number);
  
end;

/
--------------------------------------------------------
--  DDL for Package Body LBM_PCK
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "LBM_PCK" is

  g_beacon_major_id    number := 5;

  function get_menu_items
      ( p_loc_id    in  number
      , p_usr_id    in  number
      ) return varchar2 is
    l_return    varchar2(4000);
  begin
    select listagg(lmo_men_id,':') within group ( order by lmo_seqno)
      into l_return
    from   lbm_loc_menu_options
    where  lmo_loc_id = p_loc_id
      and  lmo_usr_id = p_usr_id
    ;
    return(l_return);
  end;
      
  procedure set_menu_items
      ( p_loc_id      in  number
      , p_usr_id      in  number
      , p_menu_items  in  varchar2
      ) is
    l_items    apex_application_global.vc_arr2;
  begin
    -- delete old menu entries
    delete lbm_loc_menu_options
    where  lmo_loc_id = p_loc_id
      and  lmo_usr_id = p_usr_id
    ;

    -- create new menu entries in right order
    l_items := apex_util.string_to_table(p_menu_items,':');
    for i in 1..l_items.count loop
      insert into lbm_loc_menu_options 
             ( lmo_usr_id, lmo_loc_id, lmo_men_id, lmo_seqno )
      values ( p_usr_id  , p_loc_id  , l_items(i), i )
      ;
    end loop;
    
  end;
  
  procedure set_to_location ( p_loc_id in number) is
  begin
    update lbm_location_beacons
    set lbe_major_id = lbe_minor_id  
    where lbe_major_id = g_beacon_major_id;

    update lbm_location_beacons
    set lbe_major_id = g_beacon_major_id
    where lbe_loc_id = p_loc_id;

  end;
  
end;

/
