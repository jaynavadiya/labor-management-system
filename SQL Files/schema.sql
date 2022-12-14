--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.5

-- Started on 2022-11-23 21:55:43 IST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 8 (class 2615 OID 24679)
-- Name: laborlist_and_wages_db; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA laborlist_and_wages_db;


ALTER SCHEMA laborlist_and_wages_db OWNER TO postgres;

--
-- TOC entry 252 (class 1255 OID 25117)
-- Name: check_labor_insert(); Type: FUNCTION; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE FUNCTION laborlist_and_wages_db.check_labor_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
IF EXISTS(SELECT COUNT(*) FROM labor WHERE labor_id = NEW.labor_id) THEN
	RAISE NOTICE'Duplicate Found (%)', NEW.labor_id;
	RETURN OLD;
	--IF DUPLICATE WILL BE FOUND THEN IT WILL RAISE NOTICE AND THEN RETURN OLD TABLE
END IF;
--ELSE BY DEFAULT IT WILL RETURN NEW TABLE
RETURN NEW;
END;

$$;


ALTER FUNCTION laborlist_and_wages_db.check_labor_insert() OWNER TO postgres;

--
-- TOC entry 253 (class 1255 OID 25125)
-- Name: max_work_hours(); Type: FUNCTION; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE FUNCTION laborlist_and_wages_db.max_work_hours() RETURNS TABLE(laborid integer, workhours integer)
    LANGUAGE plpgsql
    AS $$
	declare f record;
	begin
		CREATE TEMP TABLE test1(
			laborID integer,
			workHours integer
		) ON COMMIT DROP;

		for f in select labor_id, work_hours
			   from labor
			   order by work_hours DESC LIMIT 10
		loop 
		INSERT INTO test1(laborID,workHours)
			VALUES(f.labor_id,f.work_hours); --inserting those tuples into temp table
		end loop;
		return query table test1;
	end;
$$;


ALTER FUNCTION laborlist_and_wages_db.max_work_hours() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 227 (class 1259 OID 24791)
-- Name: approves; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.approves (
    user_id integer,
    leave_id integer NOT NULL,
    supervisor_id integer,
    labor_id integer NOT NULL
);


ALTER TABLE laborlist_and_wages_db.approves OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24728)
-- Name: bank_info; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.bank_info (
    account_number character varying NOT NULL,
    ifsc_code character varying NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    user_id integer NOT NULL,
    type_of_user character varying
);


ALTER TABLE laborlist_and_wages_db.bank_info OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24757)
-- Name: business_account; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.business_account (
    email character varying NOT NULL,
    account_number character varying NOT NULL
);


ALTER TABLE laborlist_and_wages_db.business_account OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 24706)
-- Name: business_info; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.business_info (
    business_id integer NOT NULL,
    location_id integer NOT NULL,
    official_id integer NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    regulated_since date,
    password character varying DEFAULT 'busy'::character varying NOT NULL
);


ALTER TABLE laborlist_and_wages_db.business_info OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 24701)
-- Name: government_officials; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.government_officials (
    official_id integer NOT NULL,
    location_id integer NOT NULL
);


ALTER TABLE laborlist_and_wages_db.government_officials OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 24802)
-- Name: hires; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.hires (
    user_id integer,
    business_id integer,
    labor_id integer NOT NULL
);


ALTER TABLE laborlist_and_wages_db.hires OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24735)
-- Name: hourly_labors; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.hourly_labors (
    labor_id integer NOT NULL,
    hourly_wage integer NOT NULL,
    hours_worked integer NOT NULL
);


ALTER TABLE laborlist_and_wages_db.hourly_labors OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 24680)
-- Name: labor; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.labor (
    labor_id integer NOT NULL,
    birth_date date NOT NULL,
    work_hours integer,
    wage_remaining money,
    rating integer,
    type_of_work character varying NOT NULL,
    supervisor_id integer NOT NULL,
    supervised_since date,
    location_id integer NOT NULL,
    account_number character varying NOT NULL,
    password character varying DEFAULT 'labor'::character varying NOT NULL
);


ALTER TABLE laborlist_and_wages_db.labor OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 24687)
-- Name: labor_supervisor; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.labor_supervisor (
    supervisor_id integer NOT NULL,
    managed_since date,
    business_id integer NOT NULL,
    location_id integer NOT NULL,
    account_number character varying NOT NULL,
    password character varying DEFAULT 'super'::character varying NOT NULL
);


ALTER TABLE laborlist_and_wages_db.labor_supervisor OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24745)
-- Name: leave; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.leave (
    leave_id integer NOT NULL,
    leave_date date NOT NULL
);


ALTER TABLE laborlist_and_wages_db.leave OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 24694)
-- Name: location_info; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.location_info (
    location_id integer NOT NULL,
    city character varying NOT NULL,
    district character varying NOT NULL
);


ALTER TABLE laborlist_and_wages_db.location_info OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24718)
-- Name: payment_info; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.payment_info (
    payment_number integer NOT NULL,
    payment_id character varying NOT NULL,
    paid_for_byhours integer NOT NULL,
    amount_paid integer NOT NULL,
    date date NOT NULL
);


ALTER TABLE laborlist_and_wages_db.payment_info OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 24776)
-- Name: pays; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.pays (
    supervisor_id integer,
    labor_id integer NOT NULL,
    payment_number integer NOT NULL,
    user_id integer
);


ALTER TABLE laborlist_and_wages_db.pays OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 24822)
-- Name: personal_info; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.personal_info (
    user_id integer,
    labor_id integer,
    supervisor_id integer,
    official_id integer,
    mobile_number bigint,
    type_of_user character varying,
    name character varying,
    email character varying NOT NULL
);


ALTER TABLE laborlist_and_wages_db.personal_info OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24725)
-- Name: schedule_info; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.schedule_info (
    schedule_id integer NOT NULL,
    entry_time time without time zone NOT NULL,
    exit_time time without time zone NOT NULL,
    date date NOT NULL
);


ALTER TABLE laborlist_and_wages_db.schedule_info OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 24807)
-- Name: schedules; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.schedules (
    user_id integer,
    supervisor_id integer,
    labor_id integer NOT NULL,
    schedule_id integer NOT NULL
);


ALTER TABLE laborlist_and_wages_db.schedules OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 24817)
-- Name: supervisor_manager; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.supervisor_manager (
    lowerlevel_supervisor_id integer NOT NULL,
    manager_id integer NOT NULL,
    supervised_since date
);


ALTER TABLE laborlist_and_wages_db.supervisor_manager OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 24794)
-- Name: takes_leave; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.takes_leave (
    user_id integer,
    leave_id integer NOT NULL,
    supervisor_id integer,
    labor_id integer NOT NULL
);


ALTER TABLE laborlist_and_wages_db.takes_leave OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24750)
-- Name: upi_info; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.upi_info (
    account_number character varying NOT NULL,
    upi_id character varying NOT NULL
);


ALTER TABLE laborlist_and_wages_db.upi_info OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24713)
-- Name: users_info; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.users_info (
    user_id integer NOT NULL,
    account_number character varying NOT NULL,
    location_id integer NOT NULL,
    password character varying DEFAULT 'majoor'::character varying NOT NULL
);


ALTER TABLE laborlist_and_wages_db.users_info OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24740)
-- Name: weekly_labors; Type: TABLE; Schema: laborlist_and_wages_db; Owner: postgres
--

CREATE TABLE laborlist_and_wages_db.weekly_labors (
    labor_id integer NOT NULL,
    weekly_wage integer NOT NULL,
    hours_worked integer NOT NULL
);


ALTER TABLE laborlist_and_wages_db.weekly_labors OWNER TO postgres;

--
-- TOC entry 3598 (class 2606 OID 25037)
-- Name: approves approve_unique; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.approves
    ADD CONSTRAINT approve_unique UNIQUE (user_id, supervisor_id, labor_id, leave_id);


--
-- TOC entry 3600 (class 2606 OID 25035)
-- Name: approves approves_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.approves
    ADD CONSTRAINT approves_pkey PRIMARY KEY (leave_id);


--
-- TOC entry 3584 (class 2606 OID 24734)
-- Name: bank_info bank_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.bank_info
    ADD CONSTRAINT bank_info_pkey PRIMARY KEY (account_number);


--
-- TOC entry 3594 (class 2606 OID 24763)
-- Name: business_account business_account_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.business_account
    ADD CONSTRAINT business_account_pkey PRIMARY KEY (email, account_number);


--
-- TOC entry 3572 (class 2606 OID 24844)
-- Name: business_info business_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.business_info
    ADD CONSTRAINT business_info_pkey PRIMARY KEY (business_id, email);


--
-- TOC entry 3568 (class 2606 OID 24870)
-- Name: government_officials government_official_uniquef; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.government_officials
    ADD CONSTRAINT government_official_uniquef UNIQUE (official_id);


--
-- TOC entry 3570 (class 2606 OID 24705)
-- Name: government_officials government_officials_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.government_officials
    ADD CONSTRAINT government_officials_pkey PRIMARY KEY (official_id);


--
-- TOC entry 3586 (class 2606 OID 24739)
-- Name: hourly_labors hourly_labors_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.hourly_labors
    ADD CONSTRAINT hourly_labors_pkey PRIMARY KEY (labor_id);


--
-- TOC entry 3562 (class 2606 OID 24693)
-- Name: labor_supervisor labopr_supervisor_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor_supervisor
    ADD CONSTRAINT labopr_supervisor_pkey PRIMARY KEY (supervisor_id);


--
-- TOC entry 3558 (class 2606 OID 24686)
-- Name: labor labor_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor
    ADD CONSTRAINT labor_pkey PRIMARY KEY (labor_id);


--
-- TOC entry 3560 (class 2606 OID 24916)
-- Name: labor labor_unique; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor
    ADD CONSTRAINT labor_unique UNIQUE (labor_id);


--
-- TOC entry 3590 (class 2606 OID 24837)
-- Name: leave leave_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.leave
    ADD CONSTRAINT leave_pkey PRIMARY KEY (leave_id);


--
-- TOC entry 3566 (class 2606 OID 24700)
-- Name: location_info location_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.location_info
    ADD CONSTRAINT location_info_pkey PRIMARY KEY (location_id);


--
-- TOC entry 3580 (class 2606 OID 24724)
-- Name: payment_info payment_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.payment_info
    ADD CONSTRAINT payment_info_pkey PRIMARY KEY (payment_number);


--
-- TOC entry 3596 (class 2606 OID 25059)
-- Name: pays pays_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.pays
    ADD CONSTRAINT pays_pkey PRIMARY KEY (payment_number);


--
-- TOC entry 3612 (class 2606 OID 24948)
-- Name: personal_info personal_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT personal_info_pkey PRIMARY KEY (email);


--
-- TOC entry 3582 (class 2606 OID 24835)
-- Name: schedule_info schedule_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.schedule_info
    ADD CONSTRAINT schedule_info_pkey PRIMARY KEY (schedule_id);


--
-- TOC entry 3606 (class 2606 OID 24972)
-- Name: schedules schedule_unique; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.schedules
    ADD CONSTRAINT schedule_unique UNIQUE (schedule_id);


--
-- TOC entry 3608 (class 2606 OID 24970)
-- Name: schedules schedules_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (schedule_id);


--
-- TOC entry 3610 (class 2606 OID 24821)
-- Name: supervisor_manager supervisor_manager_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.supervisor_manager
    ADD CONSTRAINT supervisor_manager_pkey PRIMARY KEY (lowerlevel_supervisor_id, manager_id);


--
-- TOC entry 3602 (class 2606 OID 25013)
-- Name: takes_leave takes_leave_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.takes_leave
    ADD CONSTRAINT takes_leave_pkey PRIMARY KEY (leave_id);


--
-- TOC entry 3574 (class 2606 OID 24872)
-- Name: business_info unique_business; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.business_info
    ADD CONSTRAINT unique_business UNIQUE (business_id);


--
-- TOC entry 3576 (class 2606 OID 24848)
-- Name: business_info unique_email; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.business_info
    ADD CONSTRAINT unique_email UNIQUE (email);


--
-- TOC entry 3604 (class 2606 OID 24994)
-- Name: hires unique_hire; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.hires
    ADD CONSTRAINT unique_hire UNIQUE (user_id, business_id, labor_id);


--
-- TOC entry 3614 (class 2606 OID 24940)
-- Name: personal_info unique_labor; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT unique_labor UNIQUE (labor_id);


--
-- TOC entry 3616 (class 2606 OID 24944)
-- Name: personal_info unique_official; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT unique_official UNIQUE (official_id);


--
-- TOC entry 3564 (class 2606 OID 24899)
-- Name: labor_supervisor unique_supervisor; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor_supervisor
    ADD CONSTRAINT unique_supervisor UNIQUE (supervisor_id);


--
-- TOC entry 3618 (class 2606 OID 24942)
-- Name: personal_info unique_supervisor_pinfo; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT unique_supervisor_pinfo UNIQUE (supervisor_id);


--
-- TOC entry 3620 (class 2606 OID 24946)
-- Name: personal_info unique_user; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT unique_user UNIQUE (user_id);


--
-- TOC entry 3592 (class 2606 OID 24756)
-- Name: upi_info upi_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.upi_info
    ADD CONSTRAINT upi_info_pkey PRIMARY KEY (account_number, upi_id);


--
-- TOC entry 3578 (class 2606 OID 24717)
-- Name: users_info users_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.users_info
    ADD CONSTRAINT users_info_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3588 (class 2606 OID 24744)
-- Name: weekly_labors weekly_labors_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.weekly_labors
    ADD CONSTRAINT weekly_labors_pkey PRIMARY KEY (labor_id);


--
-- TOC entry 3629 (class 2606 OID 25287)
-- Name: users_info account_number_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.users_info
    ADD CONSTRAINT account_number_fkey FOREIGN KEY (account_number) REFERENCES laborlist_and_wages_db.bank_info(account_number) NOT VALID;


--
-- TOC entry 3634 (class 2606 OID 24838)
-- Name: upi_info bank_info_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.upi_info
    ADD CONSTRAINT bank_info_fkey FOREIGN KEY (account_number) REFERENCES laborlist_and_wages_db.bank_info(account_number) NOT VALID;


--
-- TOC entry 3623 (class 2606 OID 24888)
-- Name: labor_supervisor business_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor_supervisor
    ADD CONSTRAINT business_fkey FOREIGN KEY (business_id) REFERENCES laborlist_and_wages_db.business_info(business_id) NOT VALID;


--
-- TOC entry 3647 (class 2606 OID 25000)
-- Name: hires business_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.hires
    ADD CONSTRAINT business_fkey FOREIGN KEY (business_id) REFERENCES laborlist_and_wages_db.business_info(business_id) NOT VALID;


--
-- TOC entry 3635 (class 2606 OID 25088)
-- Name: business_account email_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.business_account
    ADD CONSTRAINT email_fkey FOREIGN KEY (email) REFERENCES laborlist_and_wages_db.business_info(email) NOT VALID;


--
-- TOC entry 3626 (class 2606 OID 24873)
-- Name: business_info governemnt_official_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.business_info
    ADD CONSTRAINT governemnt_official_fkey FOREIGN KEY (official_id) REFERENCES laborlist_and_wages_db.government_officials(official_id) NOT VALID;


--
-- TOC entry 3631 (class 2606 OID 24917)
-- Name: hourly_labors labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.hourly_labors
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3632 (class 2606 OID 24922)
-- Name: weekly_labors labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.weekly_labors
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3655 (class 2606 OID 24949)
-- Name: personal_info labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3649 (class 2606 OID 24973)
-- Name: schedules labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.schedules
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3646 (class 2606 OID 24995)
-- Name: hires labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.hires
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3644 (class 2606 OID 25024)
-- Name: takes_leave labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.takes_leave
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3640 (class 2606 OID 25048)
-- Name: approves labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.approves
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3636 (class 2606 OID 25065)
-- Name: pays labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.pays
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3641 (class 2606 OID 25053)
-- Name: approves leave_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.approves
    ADD CONSTRAINT leave_fkey FOREIGN KEY (leave_id) REFERENCES laborlist_and_wages_db.takes_leave(leave_id) NOT VALID;


--
-- TOC entry 3633 (class 2606 OID 25029)
-- Name: leave leave_id_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.leave
    ADD CONSTRAINT leave_id_fkey FOREIGN KEY (leave_id) REFERENCES laborlist_and_wages_db.takes_leave(leave_id) NOT VALID;


--
-- TOC entry 3625 (class 2606 OID 24878)
-- Name: government_officials location_info_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.government_officials
    ADD CONSTRAINT location_info_fkey FOREIGN KEY (location_id) REFERENCES laborlist_and_wages_db.location_info(location_id) NOT VALID;


--
-- TOC entry 3627 (class 2606 OID 24883)
-- Name: business_info location_info_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.business_info
    ADD CONSTRAINT location_info_fkey FOREIGN KEY (location_id) REFERENCES laborlist_and_wages_db.location_info(location_id) NOT VALID;


--
-- TOC entry 3624 (class 2606 OID 24893)
-- Name: labor_supervisor location_info_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor_supervisor
    ADD CONSTRAINT location_info_fkey FOREIGN KEY (location_id) REFERENCES laborlist_and_wages_db.location_info(location_id) NOT VALID;


--
-- TOC entry 3622 (class 2606 OID 24905)
-- Name: labor location_info_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor
    ADD CONSTRAINT location_info_fkey FOREIGN KEY (location_id) REFERENCES laborlist_and_wages_db.location_info(location_id) NOT VALID;


--
-- TOC entry 3628 (class 2606 OID 25282)
-- Name: users_info location_info_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.users_info
    ADD CONSTRAINT location_info_fkey FOREIGN KEY (location_id) REFERENCES laborlist_and_wages_db.location_info(location_id) NOT VALID;


--
-- TOC entry 3654 (class 2606 OID 24932)
-- Name: supervisor_manager manager_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.supervisor_manager
    ADD CONSTRAINT manager_fkey FOREIGN KEY (manager_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3657 (class 2606 OID 24964)
-- Name: personal_info official_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT official_fkey FOREIGN KEY (official_id) REFERENCES laborlist_and_wages_db.government_officials(official_id) NOT VALID;


--
-- TOC entry 3630 (class 2606 OID 25075)
-- Name: payment_info payment_number_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.payment_info
    ADD CONSTRAINT payment_number_fkey FOREIGN KEY (payment_number) REFERENCES laborlist_and_wages_db.pays(payment_number) NOT VALID;


--
-- TOC entry 3651 (class 2606 OID 25080)
-- Name: schedules schedules_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.schedules
    ADD CONSTRAINT schedules_fkey FOREIGN KEY (schedule_id) REFERENCES laborlist_and_wages_db.schedule_info(schedule_id) NOT VALID;


--
-- TOC entry 3621 (class 2606 OID 24900)
-- Name: labor supervisor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor
    ADD CONSTRAINT supervisor_fkey FOREIGN KEY (supervisor_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3653 (class 2606 OID 24927)
-- Name: supervisor_manager supervisor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.supervisor_manager
    ADD CONSTRAINT supervisor_fkey FOREIGN KEY (lowerlevel_supervisor_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3656 (class 2606 OID 24954)
-- Name: personal_info supervisor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT supervisor_fkey FOREIGN KEY (supervisor_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3650 (class 2606 OID 24978)
-- Name: schedules supervisor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.schedules
    ADD CONSTRAINT supervisor_fkey FOREIGN KEY (supervisor_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3643 (class 2606 OID 25019)
-- Name: takes_leave supervisor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.takes_leave
    ADD CONSTRAINT supervisor_fkey FOREIGN KEY (supervisor_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3639 (class 2606 OID 25043)
-- Name: approves supervisor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.approves
    ADD CONSTRAINT supervisor_fkey FOREIGN KEY (supervisor_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3637 (class 2606 OID 25070)
-- Name: pays supervisor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.pays
    ADD CONSTRAINT supervisor_fkey FOREIGN KEY (supervisor_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3648 (class 2606 OID 25292)
-- Name: hires user_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.hires
    ADD CONSTRAINT user_fkey FOREIGN KEY (user_id) REFERENCES laborlist_and_wages_db.users_info(user_id) NOT VALID;


--
-- TOC entry 3638 (class 2606 OID 25297)
-- Name: pays user_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.pays
    ADD CONSTRAINT user_fkey FOREIGN KEY (user_id) REFERENCES laborlist_and_wages_db.users_info(user_id) NOT VALID;


--
-- TOC entry 3652 (class 2606 OID 25302)
-- Name: schedules user_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.schedules
    ADD CONSTRAINT user_fkey FOREIGN KEY (user_id) REFERENCES laborlist_and_wages_db.users_info(user_id) NOT VALID;


--
-- TOC entry 3645 (class 2606 OID 25307)
-- Name: takes_leave user_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.takes_leave
    ADD CONSTRAINT user_fkey FOREIGN KEY (user_id) REFERENCES laborlist_and_wages_db.users_info(user_id) NOT VALID;


--
-- TOC entry 3642 (class 2606 OID 25312)
-- Name: approves user_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.approves
    ADD CONSTRAINT user_fkey FOREIGN KEY (user_id) REFERENCES laborlist_and_wages_db.users_info(user_id) NOT VALID;


-- Completed on 2022-11-23 21:55:43 IST

--
-- PostgreSQL database dump complete
--

