--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;


--
-- Name: Softwarehaus; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE Projekt_Björn_Bauer IS 'Testat 4 Vorlesung Datenbank';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Löschen Tabellen des Softwarehauses
--
  	DROP TABLE if exists public.Auftraggeber cascade;
  	DROP TABLE if exists public.Auftrag cascade; 
  	DROP TABLE if exists public.Einsatz_Kurs_Kooperation_intern_extern cascade;
  	DROP TABLE if exists public.Leistungen cascade;
  	DROP TABLE if exists public.nimmt_teil_Einsatz cascade;
 	DROP TABLE if exists public.nimmt_teil_Gruppe cascade;
	DROP TABLE if exists public.Gruppe cascade;
	DROP TABLE if exists public.Einsatzmittelverwalter cascade;
	DROP TABLE if exists public.Material cascade;
	DROP TABLE if exists public.Fahrzeug cascade;
	DROP TABLE if exists public.besucht_kurs cascade;
    DROP TABLE if exists public.Kurs_Fortbildung_ cascade;
    DROP TABLE if exists public.istTeilvon_M cascade;
    DROP TABLE if exists public.istTeilvon_F cascade;
    DROP TABLE if exists public.Mitglieder cascade;
    DROP TABLE if exists public.Postleitzahl cascade;


CREATE TABLE IF NOT EXISTS Auftraggeber 
 (
   	AGN integer,
    Name varchar NOT NULL,
    Organisation varchar NOT NULL,
   	O_Typ varchar,
	Attribute varchar,
	I_E varchar NOT NULL,

	PRIMARY KEY (AGN),
	CHECK (I_E IN ('intern', 'extern')) 
);	

CREATE TABLE IF NOT EXISTS Auftrag 
(
    AN integer,
    AGN integer,
    I_E varchar NOT NULL,
    Art varchar,
    Eventtyp varchar,
    Datum_erstellt date NOT NULL,
    Datum_ausführen date NOT NULL,
    Personenzahl integer NOT NULL,
    Extras varchar,
    
   	PRIMARY KEY (AN, AGN),
    CHECK (Datum_erstellt <= NOW()),
    CHECK (Datum_ausführen > NOW()),
    CHECK (I_E IN ('intern', 'extern'))
);	


CREATE TABLE IF NOT EXISTS Einsatz_Kurs_Kooperation_intern_extern
(
    EN integer,
    AnzahlNS integer DEFAULT 0,
    AnzahlRA integer DEFAULT 0,
    AnzahlRS integer DEFAULT 0,
    AnzahlRH integer DEFAULT 0,
    AnzahlSanC integer DEFAULT 0,
    AnzahlEH integer DEFAULT 0,
    I_E varchar NOT NULL,
    Verrechnungsstelle varchar NOT NULL,
    M_O_Kosten NUMERIC(5, 2),
    Material_verbraucht varchar DEFAULT 'nichts',
    Material_eingesetzt varchar DEFAULT 'nichts',
    TeilnehmerzahlGesamt integer,
    KostenHelfer NUMERIC(5, 2),
    KostenSonstiges NUMERIC(5, 2),
    KostenFahrzeuge NUMERIC(5, 2),
    Pauschalkosten NUMERIC(5, 2) DEFAULT 1.23,
    Typ varchar,
    AN integer,
    AGN integer,
    MN integer,
    
   	PRIMARY KEY (EN),
    CHECK (I_E IN ('intern', 'extern'))
);	



CREATE TABLE IF NOT EXISTS Leistungen
(
    LN integer,
    EN integer,
    Name varchar,
    Kosten NUMERIC(5, 2),
    
   	PRIMARY KEY (LN, EN)
);	



CREATE TABLE IF NOT EXISTS nimmt_teil_Einsatz 
(
    MN integer,
    EN integer,
    PRIMARY KEY (MN, EN)
);

CREATE TABLE IF NOT EXISTS nimmt_teil_Gruppe 
(
    MN integer,
    GN integer,
    PRIMARY KEY (MN, GN)
);


CREATE TABLE IF NOT EXISTS Gruppe 
(
    GN integer,
    Ausrichtung varchar,
    Name varchar,
    G_Datum date,
    P_O varchar, 
    MN integer,
    
    PRIMARY KEY (GN),
    CHECK (G_Datum <= NOW())
);


CREATE TABLE IF NOT EXISTS Einsatzmittelverwalter 
(

    MN integer,
    Vorname varchar,
    NAchname varchar,
    ErfahrungRD boolean,
    Einweisung varchar(1) DEFAULT 'n',
    
   	PRIMARY KEY (MN),
    CHECK (Einweisung IN ('y', 'n'))
);


CREATE TABLE IF NOT EXISTS Material
 (
    MaN integer,
    Name varchar NOT NULL,
    Rufname varchar NOT NULL,
    AnbieterPrimär varchar NOT NULL,
    AnbieterSekundär varchar NOT NULL,
    KostenAP NUMERIC(5, 2),
    KostenAS NUMERIC(5, 2),
    Ablaufdatum date,
    Eingangsdatum date,
    CN integer NOT NULL,
    Medikament boolean NOT NULL,
    Materialart varchar,
    Einsatzkosten NUMERIC(5, 2),
    MegeBestand integer,
    Einsatzort varchar,
    Prüfdatum date,
    MN integer,
     
     
	PRIMARY KEY (MaN),
    CHECK (Prüfdatum <= NOW()) 
);	


CREATE TABLE IF NOT EXISTS Fahrzeug 
(
    FN integer,
    Typ varchar NOT NULL,
    Fahrererlaubnis varchar NOT NULL, 
    BeladungIdeal varchar,
    BeladungMAX varchar,
    PersonenzahlMax integer DEFAULT 2,
    Leistung integer,
    Zugehörigkeit varchar,
    Kennzeichen varchar,
    Kontrolltermin date,
    MN integer,
    
   	PRIMARY KEY (FN),
    CHECK (Kontrolltermin > NOW()) 
);


CREATE TABLE IF NOT EXISTS besucht_kurs 
(
    MN integer,
    KN integer,
    PRIMARY KEY (MN, KN)	    
);

CREATE TABLE IF NOT EXISTS istTeilvon_M 
(
    MaN integer,
    EN integer,
    PRIMARY KEY (MaN, EN)	    
);

CREATE TABLE IF NOT EXISTS istTeilvon_F 
(
    FN integer,
    EN integer,
    PRIMARY KEY (FN, EN)	    
);


CREATE TABLE IF NOT EXISTS Kurs_Fortbildung 
(
    KN integer,
    AnzahlMin integer,
    Thema varchar,
    AnzahlMax integer,
    Länge integer,
    Rubrik varchar,
    RD boolean,
    Fortbildungstyp varchar,
    Zusatz varchar,
    MN integer,
    
    
    PRIMARY KEY (KN)	    
);


CREATE TABLE IF NOT EXISTS Postleitzahl 
(
    PLZ integer,
    Ort varchar,
    Straße varchar,
    Hnr integer,
    
    PRIMARY KEY (PLZ)
);

CREATE TABLE IF NOT EXISTS Mitglieder 
(
    MN integer,
    Vorname varchar,
    Nachname varchar NOT NULL,
    GEB date NOT NULL,
    Email varchar,
    RDsoll integer,
    RDhaben integer,
    Tel_Privat integer,
    Tel_Mobil integer,
    Eintrittsdatum date,
    RechteDurchF varchar DEFAULT 'keine',
    Fahrererlaubnis varchar DEFAULT 'keine',
    K_Schutz boolean,
    EH boolean,
    SanC boolean,
    RH boolean,
    RS boolean,
    RA boolean,
    NS boolean,
    AusbildungMax varchar NOT NULL,
    PLZ integer,
    
    
    PRIMARY KEY (PLZ),
    CHECK (GEB <= NOW()),
    CHECK (Eintrittsdatum <= NOW())
);
	