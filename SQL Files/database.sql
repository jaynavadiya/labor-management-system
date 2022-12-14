--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.5

-- Started on 2022-11-23 21:56:34 IST

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
-- TOC entry 240 (class 1259 OID 25157)
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 25156)
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 242 (class 1259 OID 25165)
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 25164)
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 238 (class 1259 OID 25151)
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 25150)
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 244 (class 1259 OID 25171)
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 25179)
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 25178)
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 243 (class 1259 OID 25170)
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 248 (class 1259 OID 25185)
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 25184)
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 250 (class 1259 OID 25243)
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 25242)
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 25143)
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 25142)
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 25135)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 25134)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 251 (class 1259 OID 25271)
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- TOC entry 3879 (class 0 OID 24791)
-- Dependencies: 227
-- Data for Name: approves; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.approves (user_id, leave_id, supervisor_id, labor_id) FROM stdin;
31	1	128	119
58	2	140	62
16	3	125	75
44	4	138	97
21	5	139	76
31	6	141	65
41	7	155	86
39	8	180	73
20	9	130	66
49	10	175	85
27	11	143	98
33	12	172	119
54	13	163	107
14	14	169	61
4	15	132	79
37	16	152	62
10	17	148	115
29	18	140	98
30	19	155	88
2	20	142	82
57	21	121	73
33	22	138	68
59	23	125	99
56	24	162	119
12	25	132	106
54	26	133	114
35	27	136	93
51	28	131	66
23	29	157	117
16	30	138	89
23	31	164	85
47	32	175	109
46	33	133	70
60	34	132	120
58	35	176	82
8	36	135	116
45	37	137	65
36	38	169	83
27	39	144	70
15	40	121	111
\.


--
-- TOC entry 3872 (class 0 OID 24728)
-- Dependencies: 220
-- Data for Name: bank_info; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.bank_info (account_number, ifsc_code, name, email, user_id, type_of_user) FROM stdin;
298537795750	EJNY0635672	Dannie Symondson	dsymondson0@slate.com	1	user
544028694207	AGKK0974973	Gabbi Yeardley	gyeardley1@slashdot.org	2	user
148456509144	QGZD0738268	Maren Branford	mbranford2@google.com.br	3	user
867476259	VKXK0333604	Marven Sissland	msissland3@amazon.com	4	user
233313250426	DLAV0830391	Camila Buttler	cbuttler4@usa.gov	5	user
883007249600	HTRL0562890	Madeline Pomphrett	mpomphrett5@bloglovin.com	6	user
498375389985	XYOD0646822	Bradan Wickham	bwickham6@webnode.com	7	user
488790545998	DUDX0647187	Candide Prosch	cprosch7@geocities.jp	8	user
150860783048	IIQD0105525	Adrien Danes	adanes8@cbsnews.com	9	user
400874478344	QEVG0349615	Ingeborg Murdoch	imurdoch9@nifty.com	10	user
505389934545	IXYP0953298	Domenico Sherbrook	dsherbrooka@noaa.gov	11	user
267908092820	NCBD0669145	Lilias Confait	lconfaitb@google.de	12	user
457324950031	SSUN0096317	Gaspar Davis	gdavisc@altervista.org	13	user
57934205593	TGMH0081192	Matti Luton	mlutond@cmu.edu	14	user
79193647990	JQXR0987829	Hughie Curnnok	hcurnnoke@booking.com	15	user
922549739503	ADHI0019968	Aldin Greenhalgh	agreenhalghf@statcounter.com	16	user
7279396949	FFJP0395707	Ben Schimpke	bschimpkeg@statcounter.com	17	user
59403621618	PKXS0841510	Dru Giffaut	dgiffauth@wisc.edu	18	user
286872016277	LMFB0461682	Granny Peterkin	gpeterkini@gmpg.org	19	user
602207375039	LNZD0603255	Gothart O'Keevan	gokeevanj@cbc.ca	20	user
745530669069	CZKY0425301	Barbi Knapper	bknapperk@freewebs.com	21	user
281926212676	DFFK0270917	Christine Beckenham	cbeckenhaml@creativecommons.org	22	user
536261097680	BOOC0667533	Emmalyn Le Grand	elem@hibu.com	23	user
988311223619	IQXK0730495	Berti Muzzini	bmuzzinin@mediafire.com	24	user
437664978879	BAKU0680019	Rheta Jenken	rjenkeno@pagesperso-orange.fr	25	user
422675107573	RSRU0439608	Montgomery Wride	mwridep@fda.gov	26	user
194929388861	XIOH0342980	Desmond Godbehere	dgodbehereq@jiathis.com	27	user
190089261235	FWVJ0632307	Evvy Bennis	ebennisr@cisco.com	28	user
69043981780	NMWZ0911416	Katya Bruhnicke	kbruhnickes@uiuc.edu	29	user
193773072455	JRTP0264118	Nanni Collcutt	ncollcuttt@mapquest.com	30	user
45623858856	FBDJ0410483	Ester O'Hederscoll	eohederscollu@pagesperso-orange.fr	31	user
439636251061	RJVL0337096	Ursa Robardley	urobardleyv@smh.com.au	32	user
336694836748	CLID0972014	Rickie Kelland	rkellandw@washington.edu	33	user
60123553127	NXVP0225568	Julissa Muscat	jmuscatx@free.fr	34	user
515207506316	OJHJ0868839	Billye Vairow	bvairowy@360.cn	35	user
765505520522	RXYT0928410	Lane Puckrin	lpuckrinz@wordpress.com	36	user
203086398419	HFYB0109933	Torrin Cleugh	tcleugh10@reverbnation.com	37	user
99628626956	FMON0356852	Sydel Perford	sperford11@time.com	38	user
112579839396	BBJF0417877	Rollie Goodwill	rgoodwill12@pinterest.com	39	user
953793373891	VEHR0193134	Ludwig Royston	lroyston13@weather.com	40	user
689751141287	ORND0957045	Vinnie Southey	vsouthey14@bing.com	41	user
492640285296	VNCE0911250	Edee Tukely	etukely15@hexun.com	42	user
173201091568	MJIB0018221	Minny Chetwin	mchetwin16@economist.com	43	user
377837514449	AXBZ0600452	Cornela Feaveryear	cfeaveryear17@cdbaby.com	44	user
639707715022	QKUS0696207	Dorree Ferenczy	dferenczy18@google.it	45	user
831174199569	EITH0347868	Tracie Jehaes	tjehaes19@ehow.com	46	user
202782406327	NUBI0858209	Blane Masterson	bmasterson1a@amazon.co.uk	47	user
786203278848	WJWD0653867	Verena Gibbeson	vgibbeson1b@pcworld.com	48	user
327456736580	VDWP0796363	Ginny Mooney	gmooney1c@dailymail.co.uk	49	user
600965665889	GIPG0497856	Sawyer Sandcroft	ssandcroft1d@bravesites.com	50	user
92162256478	STCB0603688	Andrej Riglesford	ariglesford1e@exblog.jp	51	user
944476330220	VDDV0460747	Chet O' Borne	co1f@arizona.edu	52	user
399476342513	OXJW0787192	Armin Heinschke	aheinschke1g@sbwire.com	53	user
467579895000	HGMO0489982	Bern Elix	belix1h@desdev.cn	54	user
709905313539	EICI0087859	Malinde Chark	mchark1i@yellowbook.com	55	user
398743020590	XVRM0947246	Burnaby Cowle	bcowle1j@umn.edu	56	user
909658799824	LRRR0996374	Becka St. Clair	bst1k@hostgator.com	57	user
327870859249	TAHE0424479	Marijn Chappel	mchappel1l@ox.ac.uk	58	user
891644541071	DXVZ0045711	Angel Steptowe	asteptowe1m@tinypic.com	59	user
284242012079	YCKP0652950	Carney Mardee	cmardee1n@seattletimes.com	60	user
827356014688	MNPO0566879	Elsa Yardley	eyardley1o@imdb.com	61	labor
341357647563	QIQV0653376	Dougie Georgeson	dgeorgeson1p@walmart.com	62	labor
213792854742	MSYE0716489	Janaye Sealey	jsealey1q@joomla.org	63	labor
831866853300	ODMU0945876	Othilia Firman	ofirman1r@stumbleupon.com	64	labor
706015395842	ALIF0753672	Hirsch Charlotte	hcharlotte1s@sciencedirect.com	65	labor
771397699693	LLBZ0551529	Elbertina Dulake	edulake1t@pen.io	66	labor
181975498102	KSQS0831593	Estel Hartill	ehartill1u@issuu.com	67	labor
74403052323	KBDJ0049770	Sargent Plackstone	splackstone1v@skyrock.com	68	labor
520484572504	DTOC0425591	Dian Dmiterko	ddmiterko1w@biblegateway.com	69	labor
864319055778	PJIU0559937	Lexine Ganter	lganter1x@deliciousdays.com	70	labor
542765434017	FDDQ0415400	Bernardina Sidsaff	bsidsaff1y@sun.com	71	labor
926811920358	XNJD0849107	Jacinta Giffin	jgiffin1z@mapquest.com	72	labor
440630000275	HXLI0019901	Jori Ogglebie	jogglebie20@deviantart.com	73	labor
106796877612	BRYV0057046	Ora Weddell	oweddell21@omniture.com	74	labor
655114191614	CVJY0539105	Bordy Baty	bbaty22@java.com	75	labor
885831183161	SFXG0174500	Sheffie Jebb	sjebb23@tumblr.com	76	labor
162844334608	VKYT0377888	Trumann May	tmay24@microsoft.com	77	labor
711875587690	DVVX0225114	Timmi Kleynen	tkleynen25@cam.ac.uk	78	labor
215290900210	SAHD0040043	Haley Sandels	hsandels26@last.fm	79	labor
367823883118	SRCC0703913	Kakalina Adshad	kadshad27@cyberchimps.com	80	labor
972935202161	QDMV0024907	Carlotta Date	cdate28@ucoz.ru	81	labor
919018688186	XVLH0920851	Garwood Jellard	gjellard29@weebly.com	82	labor
245521580923	GPWL0914286	Mureil Ballard	mballard2a@businessweek.com	83	labor
790349530906	RXEA0786982	Quentin Pheazey	qpheazey2b@wiley.com	84	labor
169986888059	TDEW0505220	Stewart Tourmell	stourmell2c@usnews.com	85	labor
174034333510	PYRT0365499	Lorrin Ourry	lourry2d@prlog.org	86	labor
242987258224	AUOH0754474	Nanette Smethurst	nsmethurst2e@sfgate.com	87	labor
896476066901	FIIK0582009	Coleman Lindelof	clindelof2f@etsy.com	88	labor
348431273747	LGPB0460345	Bethany Angrave	bangrave2g@yale.edu	89	labor
404155110275	CMJZ0235474	Nadine Raincin	nraincin2h@sourceforge.net	90	labor
940465026141	OREM0049198	Prince Courtliff	pcourtliff2i@unesco.org	91	labor
701973679986	ZXTM0935127	Libby Glyne	lglyne2j@sitemeter.com	92	labor
625550046533	XDFM0388808	Christean Mabon	cmabon2k@bigcartel.com	93	labor
124029518183	PNPX0071689	Eleanor Culverhouse	eculverhouse2l@cnn.com	94	labor
343455011781	DZZY0416257	Efren Oldnall	eoldnall2m@discovery.com	95	labor
131331128588	DERZ0919351	Bastian Lowthorpe	blowthorpe2n@alibaba.com	96	labor
757806640822	ZMXD0117743	Franky Spooner	fspooner2o@yelp.com	97	labor
370163207306	OLMJ0650328	Freida Arkil	farkil2p@icq.com	98	labor
133982615930	CBAR0966323	Konstance Casterton	kcasterton2q@domainmarket.com	99	labor
586590007588	SYGV0577722	Cristi Emma	cemma2r@gravatar.com	100	labor
124611301056	KOJC0577531	Meredith Kaszper	mkaszper2s@unblog.fr	101	labor
939540852075	KVBR0284168	Vicki Vanne	vvanne2t@diigo.com	102	labor
577183872997	RIGY0057611	Evyn Langtree	elangtree2u@japanpost.jp	103	labor
810529517553	OZAI0389451	Stanislaus Eagle	seagle2v@earthlink.net	104	labor
31614917085	QBIC0409121	Rene McQuaid	rmcquaid2w@hibu.com	105	labor
372984215091	PAAT0625488	Manny Goode	mgoode2x@miibeian.gov.cn	106	labor
50935258662	ATQJ0258656	Quintus Ellerington	qellerington2y@irs.gov	107	labor
665271732320	ATTI0024403	Christan Bennetto	cbennetto2z@reddit.com	108	labor
398508972717	OWZZ0877911	Chic Bottini	cbottini30@gmpg.org	109	labor
247491963926	NVVM0959205	Charisse Axleby	caxleby31@twitpic.com	110	labor
938295692024	RQVB0080377	Arvy Coggill	acoggill32@chicagotribune.com	111	labor
421972594662	HBME0422942	Saba Quinet	squinet33@google.com.br	112	labor
466220673016	KPHD0536443	Dacy Ineson	dineson34@shutterfly.com	113	labor
566291743909	OQZF0131931	Karla Craighill	kcraighill35@youtube.com	114	labor
702076334845	MEBK0780308	Guntar Aronstam	garonstam36@cargocollective.com	115	labor
856939111874	JBOI0081003	Monro Brownsworth	mbrownsworth37@xrea.com	116	labor
658130716774	FOGA0337747	Nara Bernardoux	nbernardoux38@ucoz.com	117	labor
708116024769	ESOL0123931	Robyn Bazoche	rbazoche39@plala.or.jp	118	labor
991434927056	SVQG0697341	Lynea Bradbury	lbradbury3a@wordpress.com	119	labor
264183937513	YIYR0510687	Selena Geoghegan	sgeoghegan3b@hugedomains.com	120	labor
918850167327	RQSG0064537	Merola Morales	mmorales3c@51.la	121	supervisor
514123985878	HSFZ0224467	Chester Tims	ctims3d@nbcnews.com	122	supervisor
833321069641	XVPZ0037521	Mallorie Grzes	mgrzes3e@mediafire.com	123	supervisor
493344411423	HVPD0488765	Amie Redholes	aredholes3f@eventbrite.com	124	supervisor
491223410475	OIQL0959479	Avril Ninnoli	aninnoli3g@studiopress.com	125	supervisor
729147815677	RXMF0665887	Aprilette Lantoph	alantoph3h@psu.edu	126	supervisor
848314642376	CQNZ0719681	Gabrielle Slide	gslide3i@tamu.edu	127	supervisor
665939567382	YIAK0115840	Roxi Gilchrist	rgilchrist3j@bandcamp.com	128	supervisor
422972110819	XDHA0183819	Jacob Kubica	jkubica3k@redcross.org	129	supervisor
855382782821	GVFB0069975	Alejandro Messier	amessier3l@kickstarter.com	130	supervisor
310771477107	PAQJ0114654	Dallas Crocetto	dcrocetto3m@istockphoto.com	131	supervisor
24299684311	UPVZ0537030	Gawen McCullouch	gmccullouch3n@phpbb.com	132	supervisor
722641505880	OIYY0619169	Vanya Ragless	vragless3o@domainmarket.com	133	supervisor
235176531055	AHLP0796418	Danya Shasnan	dshasnan3p@mozilla.org	134	supervisor
230251297309	GCEW0246261	Willi Pedley	wpedley3q@google.de	135	supervisor
856879060417	PDUJ0365152	Nichol Chatfield	nchatfield3r@imageshack.us	136	supervisor
466879496372	XVUL0454733	Stephi Hobble	shobble3s@wsj.com	137	supervisor
85848437520	BOUG0532583	Harriette Burniston	hburniston3t@uiuc.edu	138	supervisor
145810273412	CIHH0223307	Nikki Gerritzen	ngerritzen3u@diigo.com	139	supervisor
684395208302	DQTM0851233	Trude Husthwaite	thusthwaite3v@wiley.com	140	supervisor
845323419946	TMRU0933962	Shanan Freer	sfreer3w@oakley.com	141	supervisor
316169727019	HOIA0767168	Brnaba Poff	bpoff3x@sciencedirect.com	142	supervisor
899293837273	ORXX0486565	Vince Faire	vfaire3y@google.co.uk	143	supervisor
347988875692	XIIQ0306263	Auroora Lupson	alupson3z@mysql.com	144	supervisor
541794237722	FQCX0215517	Byran Canete	bcanete40@scientificamerican.com	145	supervisor
563192243577	QGMX0922521	Laird Pywell	lpywell41@multiply.com	146	supervisor
513953767143	GUEW0801498	Esther Sehorsch	esehorsch42@microsoft.com	147	supervisor
783951825379	HPRP0210232	Aleta Bendix	abendix43@nsw.gov.au	148	supervisor
248330950980	LADB0386494	Bron Simonou	bsimonou44@imdb.com	149	supervisor
251176053002	RHOG0540562	Edsel Kenafaque	ekenafaque45@ameblo.jp	150	supervisor
818916563321	MZSB0369397	Andonis Grece	agrece46@state.tx.us	151	supervisor
104652962105	LZGZ0439145	Eryn Turvie	eturvie47@twitpic.com	152	supervisor
537259753836	BDOT0593394	Doretta Axtell	daxtell48@deviantart.com	153	supervisor
133233020353	UUCS0597686	Carmon Payn	cpayn49@weather.com	154	supervisor
399583802029	FUWU0451003	Mitchel Perutto	mperutto4a@constantcontact.com	155	supervisor
385792511123	MILO0562791	Yvonne Ruppelin	yruppelin4b@storify.com	156	supervisor
478712518297	RCBU0493771	Xenia Slopier	xslopier4c@loc.gov	157	supervisor
343333834345	OHAU0954724	Tabbie Ligoe	tligoe4d@businessinsider.com	158	supervisor
970312540833	XMTK0703828	Tiffy Rivers	trivers4e@sphinn.com	159	supervisor
90978019034	NMTC0717066	Judon Hasel	jhasel4f@amazon.co.uk	160	supervisor
797843958812	YZRH0639423	Mavra Giacomuzzo	mgiacomuzzo4g@latimes.com	161	supervisor
970447962812	VDCA0170773	Bab Banton	bbanton4h@china.com.cn	162	supervisor
313117679957	XBCO0187188	Brewster Dionisi	bdionisi4i@digg.com	163	supervisor
600232347547	QXAI0966463	Veronike Riglesford	vriglesford4j@mashable.com	164	supervisor
630018021767	EWGD0694660	Man Sill	msill4k@miibeian.gov.cn	165	supervisor
461278986331	NSHO0896814	Vivianna Tredger	vtredger4l@washington.edu	166	supervisor
748124513430	OJVR0075886	Stuart Venners	svenners4m@walmart.com	167	supervisor
642113948110	QSWU0912231	Samson Amphlett	samphlett4n@fda.gov	168	supervisor
920421015313	NXLP0265978	Gustav Causley	gcausley4o@devhub.com	169	supervisor
295846757930	FDJU0520620	Hermy Cargen	hcargen4p@about.com	170	supervisor
843749057076	TSEL0185158	Randie Robbe	rrobbe4q@ebay.co.uk	171	supervisor
620017149865	JJII0859135	Waldon Arlott	warlott4r@addthis.com	172	supervisor
881638162430	DEQT0601572	Sara-ann Filtness	sfiltness4s@ask.com	173	supervisor
78251800659	QFOK0704568	Emelyne Mathy	emathy4t@posterous.com	174	supervisor
7517108588	WTTV0673839	Briano Heiner	bheiner4u@pen.io	175	supervisor
207921772999	CZFD0795086	Jobi Keith	jkeith4v@barnesandnoble.com	176	supervisor
42334705665	UWUV0495234	Troy Cowles	tcowles4w@posterous.com	177	supervisor
400569441999	NHPY0767476	Jakie Cappineer	jcappineer4x@cbsnews.com	178	supervisor
863840611764	BOMV0105103	Vic Maypes	vmaypes4y@cafepress.com	179	supervisor
709971905203	WJOW0353974	Gerianne Leask	gleask4z@shinystat.com	180	supervisor
246423547831	UGRW0794353	Roth Stollery	rstollery50@newyorker.com	181	business
395705930861	IOTH0798000	Evyn Skate	eskate51@nasa.gov	182	business
833157994886	WQUX0037010	Teena Fransson	tfransson52@reuters.com	183	business
988325858852	HAIL0431708	Cesaro Swinfen	cswinfen53@biglobe.ne.jp	184	business
999643202382	ZKOP0195257	Jimmy Poynton	jpoynton54@flavors.me	185	business
642469436045	ORGB0301006	Calypso Litchfield	clitchfield55@blogger.com	186	business
710981170695	WKJQ0758779	Homere Blackley	hblackley56@cdc.gov	187	business
724174518559	MNRD0461635	Charyl Lorek	clorek57@amazon.com	188	business
366436653358	DRIO0101152	Bailie Janowicz	bjanowicz58@ftc.gov	189	business
548391035835	FNYS0353937	Franky Coule	fcoule59@state.gov	190	business
292403716483	RBLO0630860	Anna-diane Josephson	ajosephson5a@ezinearticles.com	191	business
580452551897	AEGH0467689	Algernon Edgerley	aedgerley5b@discuz.net	192	business
140560588056	AGUW0342846	Joachim Pagan	jpagan5c@devhub.com	193	business
771822757812	GPXW0541814	Willi Elgar	welgar5d@so-net.ne.jp	194	business
869451373225	SOXJ0813389	Anabal Sherebrook	asherebrook5e@elpais.com	195	business
271551190981	BGXC0172270	Guilbert O'Hdirscoll	gohdirscoll5f@oaic.gov.au	196	business
734095776864	YJFK0060889	Shaine Heliet	sheliet5g@hibu.com	197	business
266785702706	XZZG0031270	Otis Bolduc	obolduc5h@dyndns.org	198	business
701870281052	MFPI0260394	Esra Royston	eroyston5i@paginegialle.it	199	business
345674565389	KSVM0512399	Sunny Vinden	svinden5j@yellowbook.com	200	business
748485350976	VYHV0560059	Lavena Maber	lmaber5k@topsy.com	201	business
569239797065	NNSY0291360	Coraline Acuna	cacuna5l@51.la	202	business
853742400437	UCRF0765135	Obadiah Simpson	osimpson5m@multiply.com	203	business
932401608225	IFBH0468687	Annabal Davioud	adavioud5n@pinterest.com	204	business
969049800981	WJIJ0810355	Adelina Alderson	aalderson5o@nhs.uk	205	business
993215436396	GXEO0408551	Lamond Fetterplace	lfetterplace5p@dagondesign.com	206	business
576448477601	RFBJ0416263	Gavan Glover	gglover5q@yellowpages.com	207	business
335501243015	OIWH0929914	Cynthea Chesher	cchesher5r@epa.gov	208	business
624504249609	YCDW0067032	Lazaro Huxton	lhuxton5s@japanpost.jp	209	business
402716561802	XZZK0361677	Afton Noye	anoye5t@shutterfly.com	210	business
263590314709	ZVCL0933544	Adlai Cuel	acuel5u@wsj.com	211	business
674580314602	PREN0172610	Louella Massen	lmassen5v@google.com.hk	212	business
560306362853	VZIZ0992734	Pace Iltchev	piltchev5w@google.com	213	business
94689789663	HIKI0820548	Dorian Nudde	dnudde5x@europa.eu	214	business
240835296611	LUFK0979269	Teddy Fradgley	tfradgley5y@prweb.com	215	business
310976388514	OXKF0614005	Lisabeth Buddock	lbuddock5z@marketwatch.com	216	business
98565461268	PMZH0948078	Vidovik Ballinger	vballinger60@issuu.com	217	business
157893350626	VBER0934143	Kelsy Matus	kmatus61@furl.net	218	business
390476566225	RTGF0638470	Gisele Grinval	ggrinval62@ft.com	219	business
334642567221	RHJZ0898723	Martita Perry	mperry63@msn.com	220	business
873581500342	BDUB0424906	Melody Tarling	mtarling64@scientificamerican.com	221	business
646701647196	CQGU0975276	Kevon Giffon	kgiffon65@cbc.ca	222	business
501425353971	PVFH0783593	Slade Wenger	swenger66@virginia.edu	223	business
230083194186	WWSG0506349	Debi Broomfield	dbroomfield67@t-online.de	224	business
895261499652	MTWY0063366	Cami Ibbison	cibbison68@irs.gov	225	business
538476151760	DBCC0012075	Gregorius Lomax	glomax69@mit.edu	226	business
248636462147	YHWC0442001	Paula Burnage	pburnage6a@github.com	227	business
593807564373	NKWL0369504	Borg Hoogendorp	bhoogendorp6b@creativecommons.org	228	business
985016232642	HIRV0525799	Kienan Grinstead	kgrinstead6c@mysql.com	229	business
749881299383	CESG0950514	Isac Want	iwant6d@istockphoto.com	230	business
379611740958	ZTYB0481584	Mathe Lammertz	mlammertz6e@e-recht24.de	231	business
803415158774	UVTE0340595	Tore Hultberg	thultberg6f@facebook.com	232	business
899938368953	TUJE0437227	Dorice Westcott	dwestcott6g@rambler.ru	233	business
450875033771	KXIV0962282	Tate Guiver	tguiver6h@etsy.com	234	business
513784478960	QKFS0478016	Ralina Basnett	rbasnett6i@tinypic.com	235	business
389977804907	OZAH0249480	Gerrie Siviour	gsiviour6j@ftc.gov	236	business
946683106255	ZZEZ0740115	Francoise Freund	ffreund6k@xrea.com	237	business
978522973153	UIKQ0873683	Hamlin Fabri	hfabri6l@drupal.org	238	business
230275339857	AGWK0312252	Olva Wickens	owickens6m@cbslocal.com	239	business
161376655877	ORNB0142808	Jaquith Giorgio	jgiorgio6n@ovh.net	240	business
881308692856	SXGM0474227	Desdemona Hannen	dhannen6o@vimeo.com	241	official
214592769917	XSVU0428821	Tuckie Moyce	tmoyce6p@skype.com	242	official
688383411152	FNQU0576565	Lenka Honeyghan	lhoneyghan6q@exblog.jp	243	official
175870743659	MOYB0940084	Claudell Skill	cskill6r@wufoo.com	244	official
526017445041	NFEW0944475	Maurice Lynas	mlynas6s@springer.com	245	official
850671125536	OEAN0721002	Bridgette Andino	bandino6t@artisteer.com	246	official
383107648846	GJFN0643670	Isidoro Ryce	iryce6u@a8.net	247	official
30098574862	NIIC0782235	Latisha Seefeldt	lseefeldt6v@webeden.co.uk	248	official
208268585411	DJLS0106920	Celka Sloyan	csloyan6w@1und1.de	249	official
91525987565	JPTP0074927	Chere Weathers	cweathers6x@wsj.com	250	official
483086799517	DTJE0311854	Maxim Nerger	mnerger6y@dion.ne.jp	251	official
487882694416	OOHG0446033	Florry Tawton	ftawton6z@g.co	252	official
920071180067	FFLA0095964	Hube Nelissen	hnelissen70@list-manage.com	253	official
83658461192	KGHH0945783	Maressa Hawkett	mhawkett71@samsung.com	254	official
470104711001	OYAE0067048	Aeriell Orchart	aorchart72@reuters.com	255	official
717261796562	EMIT0432971	Felicle Jenyns	fjenyns73@abc.net.au	256	official
383078614782	XIAM0367586	Pancho Trim	ptrim74@flavors.me	257	official
90767238096	MYUT0889920	Wally Danaher	wdanaher75@google.ca	258	official
106014000232	KVGZ0405254	Larry Alp	lalp76@noaa.gov	259	official
369330534261	TACT0302678	Ivar Hurring	ihurring77@discuz.net	260	official
303324288696	EDJU0726557	Akim Meeus	ameeus78@blogs.com	261	official
552452579289	TSQZ0610863	Ginni Nichol	gnichol79@dedecms.com	262	official
842293386332	AUGH0014901	Frannie Banes	fbanes7a@yolasite.com	263	official
60448491706	VYYV0169898	Minette Storch	mstorch7b@t-online.de	264	official
399450728078	HAPH0301285	Esta McLay	emclay7c@merriam-webster.com	265	official
557256395402	YSYH0015776	Devondra Rubury	drubury7d@eepurl.com	266	official
478204174204	PKSJ0878229	Boycie Hane	bhane7e@aboutads.info	267	official
434841625959	KLBA0190115	Terrance Essex	tessex7f@cbc.ca	268	official
959323858288	XVFG0949543	Becky Sallans	bsallans7g@wp.com	269	official
807015188638	XKFS0141365	Ellene Doxsey	edoxsey7h@wufoo.com	270	official
845219995540	TTTQ0656748	Sukey Rolance	srolance7i@wordpress.com	271	official
865609309771	OWYI0798973	Christiana Leng	cleng7j@webmd.com	272	official
164310188380	RXQI0476100	Sheff Gilcrist	sgilcrist7k@ft.com	273	official
405919179679	MHPO0156537	Kris Szymaniak	kszymaniak7l@twitpic.com	274	official
540134541066	GXQL0268419	Lorain Rulten	lrulten7m@netvibes.com	275	official
347366635183	KSDO0077231	Star Sambells	ssambells7n@xinhuanet.com	276	official
171911829972	BQGM0582587	Tadeo Burgoyne	tburgoyne7o@vimeo.com	277	official
984604090840	XPHF0564242	Kassandra McClaurie	kmcclaurie7p@meetup.com	278	official
307173032517	CYKI0072391	Karina Woolbrook	kwoolbrook7q@moonfruit.com	279	official
107302617230	ZMVW0130356	Alix Skains	askains7r@elegantthemes.com	280	official
677452557782	VJBT0130933	Ettore Snelgar	esnelgar7s@thetimes.co.uk	281	official
133299417541	GUKP0247014	Viviene Casterton	vcasterton7t@foxnews.com	282	official
831213613493	TCQE0936619	Rudolfo Blooman	rblooman7u@stumbleupon.com	283	official
75526734143	EVKR0571319	Deny Welds	dwelds7v@mail.ru	284	official
801784685370	OJOL0744017	Myrvyn Yackiminie	myackiminie7w@jigsy.com	285	official
445801155986	ZFYD0808256	Tally Mellor	tmellor7x@nyu.edu	286	official
81946418498	BSGX0120652	Brady McKeighan	bmckeighan7y@yolasite.com	287	official
46239216563	OWOP0646745	Kristel Norvell	knorvell7z@home.pl	288	official
119393631681	CAWV0221116	Maurise Pinock	mpinock80@hhs.gov	289	official
87734244525	NONQ0674954	Perla Cannop	pcannop81@google.es	290	official
632284086494	LEFM0205411	Filia Carah	fcarah82@sitemeter.com	291	official
938714120379	PWTC0141003	Fredra Livard	flivard83@telegraph.co.uk	292	official
426149648409	XIIW0884801	Leo Floyed	lfloyed84@digg.com	293	official
396748403544	IDUQ0510262	Olympe Lovegrove	olovegrove85@bbc.co.uk	294	official
139966889123	MZPI0061717	Mattheus Duesberry	mduesberry86@toplist.cz	295	official
644590694063	DZCX0753429	Lani Heintze	lheintze87@ask.com	296	official
451942038420	GDUQ0247565	Anett Bertson	abertson88@bluehost.com	297	official
351274097626	MLGU0170961	Niki Mallabund	nmallabund89@ocn.ne.jp	298	official
799391148148	FGIU0157716	Doretta Caney	dcaney8a@bloglines.com	299	official
611753380596	MJKF0279467	Querida Mendenhall	qmendenhall8b@utexas.edu	300	official
8543914	62793773	Jay Navadiya	dbnavadiya@gmail.com	301	user
3983320	761232963	Jay Navadiya	dbnavadiya@gmail.com	542	user
6076996	484423100	Jay Navadiya	dbnavadiya@gmail.com	783	user
6680981	600878995	Jay Navadiya	dbnavadiya@gmail.com	1024	user
9931504	204197843	Jay Navadiya	dbnavadiya@gmail.com	1265	user
932149	123759490	Jay Navadiya	dbnavadiya@gmail.com	361	labor
3460328	994089438	Jay Navadiya	dbnavadiya@gmail.com	361	labor
2126135	3596708	Jay Navadiya	dbnavadiya@gmail.com	361	labor
456423	501376948	Jay Navadiya	dbnavadiya@gmail.com	361	labor
3669014	717268160	Jay Navadiya	dbnavadiya@gmail.com	361	labor
8390153	305589896	Jay Navadiya	dbnavadiya@gmail.com	361	labor
2543365	682152713	Jay Navadiya	dbnavadiya@gmail.com	361	labor
9461617	871322857	Jay Navadiya	dbnavadiya@gmail.com	361	labor
4939981	378831356	Jay Navadiya	dbnavadiya@gmail.com	361	labor
5545303	593376902	Jay Navadiya	dbnavadiya@gmail.com	361	labor
2629865	236629482	Jay Navadiya	dbnavadiya@gmail.com	361	labor
4373296	173354188	Jay Navadiya	dbnavadiya@gmail.com	361	labor
4066249	176536943	Jay Navadiya	dbnavadiya@gmail.com	361	labor
6138922	343408073	Jay Navadiya	dbnavadiya@gmail.com	361	labor
6894077	647661091	Jay Navadiya	dbnavadiya@gmail.com	421	supervisor
7275303	927549892	Jay Navadiya	dbnavadiya@gmail.com	662	supervisor
2878525	286350264	Jay Navadiya	dbnavadiya@gmail.com	662	supervisor
1168010	701248130	Jay Navadiya	dbnavadiya@gmail.com	662	supervisor
6923456	331941655	Jay Navadiya	dbnavadiya@gmail.com	481	business
\.


--
-- TOC entry 3877 (class 0 OID 24757)
-- Dependencies: 225
-- Data for Name: business_account; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.business_account (email, account_number) FROM stdin;
rstollery50@newyorker.com	246423547831
eskate51@nasa.gov	395705930861
tfransson52@reuters.com	833157994886
cswinfen53@biglobe.ne.jp	988325858852
jpoynton54@flavors.me	999643202382
clitchfield55@blogger.com	642469436045
hblackley56@cdc.gov	710981170695
clorek57@amazon.com	724174518559
bjanowicz58@ftc.gov	366436653358
fcoule59@state.gov	548391035835
ajosephson5a@ezinearticles.com	292403716483
aedgerley5b@discuz.net	580452551897
jpagan5c@devhub.com	140560588056
welgar5d@so-net.ne.jp	771822757812
asherebrook5e@elpais.com	869451373225
gohdirscoll5f@oaic.gov.au	271551190981
sheliet5g@hibu.com	734095776864
obolduc5h@dyndns.org	266785702706
eroyston5i@paginegialle.it	701870281052
svinden5j@yellowbook.com	345674565389
lmaber5k@topsy.com	748485350976
cacuna5l@51.la	569239797065
osimpson5m@multiply.com	853742400437
adavioud5n@pinterest.com	932401608225
aalderson5o@nhs.uk	969049800981
lfetterplace5p@dagondesign.com	993215436396
gglover5q@yellowpages.com	576448477601
cchesher5r@epa.gov	335501243015
lhuxton5s@japanpost.jp	624504249609
anoye5t@shutterfly.com	402716561802
acuel5u@wsj.com	263590314709
lmassen5v@google.com.hk	674580314602
piltchev5w@google.com	560306362853
dnudde5x@europa.eu	94689789663
tfradgley5y@prweb.com	240835296611
lbuddock5z@marketwatch.com	310976388514
vballinger60@issuu.com	98565461268
kmatus61@furl.net	157893350626
ggrinval62@ft.com	390476566225
mperry63@msn.com	334642567221
mtarling64@scientificamerican.com	873581500342
kgiffon65@cbc.ca	646701647196
swenger66@virginia.edu	501425353971
dbroomfield67@t-online.de	230083194186
cibbison68@irs.gov	895261499652
glomax69@mit.edu	538476151760
pburnage6a@github.com	248636462147
bhoogendorp6b@creativecommons.org	593807564373
kgrinstead6c@mysql.com	985016232642
iwant6d@istockphoto.com	749881299383
mlammertz6e@e-recht24.de	379611740958
thultberg6f@facebook.com	803415158774
dwestcott6g@rambler.ru	899938368953
tguiver6h@etsy.com	450875033771
rbasnett6i@tinypic.com	513784478960
gsiviour6j@ftc.gov	389977804907
ffreund6k@xrea.com	946683106255
hfabri6l@drupal.org	978522973153
owickens6m@cbslocal.com	230275339857
jgiorgio6n@ovh.net	161376655877
\.


--
-- TOC entry 3868 (class 0 OID 24706)
-- Dependencies: 216
-- Data for Name: business_info; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.business_info (business_id, location_id, official_id, name, email, regulated_since, password) FROM stdin;
181	3152	247	Collins and Sons	rstollery50@newyorker.com	2021-12-30	busy
182	3146	255	Wiegand-Koelpin	eskate51@nasa.gov	2022-10-21	busy
183	3159	271	Quigley-Hudson	tfransson52@reuters.com	2022-08-11	busy
184	3160	286	Turcotte, Weber and Hermann	cswinfen53@biglobe.ne.jp	2022-05-20	busy
185	3139	297	Muller, Lesch and Bogan	jpoynton54@flavors.me	2022-04-03	busy
186	3124	273	Hodkiewicz, Fay and Predovic	clitchfield55@blogger.com	2022-03-23	busy
187	3113	247	Ziemann-Hintz	hblackley56@cdc.gov	2022-02-19	busy
188	3150	291	Fisher-Parisian	clorek57@amazon.com	2022-09-06	busy
189	3135	268	McClure-Casper	bjanowicz58@ftc.gov	2022-01-05	busy
190	3155	241	Walker and Sons	fcoule59@state.gov	2022-07-16	busy
191	3159	300	Nolan-Grady	ajosephson5a@ezinearticles.com	2022-01-31	busy
192	3140	293	Bauch, Larkin and Howell	aedgerley5b@discuz.net	2021-12-13	busy
193	3157	244	Robel, Schamberger and Olson	jpagan5c@devhub.com	2022-09-19	busy
194	3137	243	Erdman, Dickinson and Kassulke	welgar5d@so-net.ne.jp	2022-09-11	busy
195	3105	265	Konopelski Inc	asherebrook5e@elpais.com	2022-02-04	busy
196	3116	291	Tillman Inc	gohdirscoll5f@oaic.gov.au	2022-04-04	busy
197	3159	278	Kub, Kuphal and Gaylord	sheliet5g@hibu.com	2022-03-14	busy
198	3104	264	Emmerich-Ratke	obolduc5h@dyndns.org	2022-08-12	busy
199	3109	243	Hilll, Gorczany and Crona	eroyston5i@paginegialle.it	2022-08-01	busy
200	3124	287	Rowe and Sons	svinden5j@yellowbook.com	2022-10-14	busy
201	3114	282	Runolfsdottir Group	lmaber5k@topsy.com	2022-03-27	busy
202	3117	291	Roberts Inc	cacuna5l@51.la	2022-08-20	busy
203	3137	262	Rath-Ondricka	osimpson5m@multiply.com	2022-02-24	busy
204	3103	266	Emmerich, Goyette and Jacobs	adavioud5n@pinterest.com	2022-10-23	busy
205	3155	242	Kris, Koss and Green	aalderson5o@nhs.uk	2022-02-25	busy
206	3148	253	Heidenreich-Jones	lfetterplace5p@dagondesign.com	2022-06-27	busy
207	3133	296	Boyle-Ratke	gglover5q@yellowpages.com	2022-02-18	busy
208	3121	289	Zemlak Inc	cchesher5r@epa.gov	2022-11-04	busy
209	3151	243	Cremin LLC	lhuxton5s@japanpost.jp	2022-01-31	busy
210	3116	271	Spencer, Paucek and Dare	anoye5t@shutterfly.com	2022-07-23	busy
211	3137	271	Renner-Kuhic	acuel5u@wsj.com	2022-07-03	busy
212	3123	258	Lowe, Cremin and Larkin	lmassen5v@google.com.hk	2021-12-25	busy
213	3159	249	Boehm-Ortiz	piltchev5w@google.com	2022-04-23	busy
214	3137	254	Waelchi, Braun and Hammes	dnudde5x@europa.eu	2022-04-04	busy
215	3135	263	Goodwin and Sons	tfradgley5y@prweb.com	2022-03-01	busy
216	3152	257	Krajcik LLC	lbuddock5z@marketwatch.com	2022-09-30	busy
217	3146	266	Stracke and Sons	vballinger60@issuu.com	2022-05-22	busy
218	3157	292	Fadel-Gibson	kmatus61@furl.net	2022-06-04	busy
219	3132	270	Koepp, Gottlieb and King	ggrinval62@ft.com	2022-03-28	busy
220	3121	272	Bogan, Kirlin and Greenholt	mperry63@msn.com	2022-06-16	busy
221	3138	276	Romaguera, Gerhold and Sauer	mtarling64@scientificamerican.com	2022-08-06	busy
222	3112	288	Sporer-Grimes	kgiffon65@cbc.ca	2022-03-08	busy
223	3149	262	Terry Inc	swenger66@virginia.edu	2022-08-30	busy
224	3107	300	Bruen-Hayes	dbroomfield67@t-online.de	2022-02-20	busy
225	3132	270	Emmerich-Rippin	cibbison68@irs.gov	2022-07-31	busy
226	3160	275	Brekke, Herzog and Trantow	glomax69@mit.edu	2022-05-24	busy
227	3102	298	Homenick, Runolfsson and Price	pburnage6a@github.com	2022-05-22	busy
228	3157	248	Cole-Hirthe	bhoogendorp6b@creativecommons.org	2022-08-07	busy
229	3139	262	Stoltenberg-Terry	kgrinstead6c@mysql.com	2022-02-09	busy
230	3131	277	Flatley-Balistreri	iwant6d@istockphoto.com	2022-06-13	busy
231	3155	272	VonRueden, Turcotte and Schaden	mlammertz6e@e-recht24.de	2022-07-08	busy
232	3139	293	White-Reilly	thultberg6f@facebook.com	2022-04-24	busy
233	3125	278	Casper-Dach	dwestcott6g@rambler.ru	2022-03-13	busy
234	3149	253	Leuschke, Reilly and Monahan	tguiver6h@etsy.com	2022-01-20	busy
235	3116	246	Hagenes and Sons	rbasnett6i@tinypic.com	2021-12-12	busy
236	3139	252	Macejkovic-Kiehn	gsiviour6j@ftc.gov	2022-01-20	busy
237	3128	247	Hansen-Mohr	ffreund6k@xrea.com	2022-09-16	busy
238	3146	281	Glover, Farrell and Langosh	hfabri6l@drupal.org	2022-05-06	busy
239	3111	272	Crist, Morissette and Kilback	owickens6m@cbslocal.com	2022-04-30	busy
240	3119	254	Schuster LLC	jgiorgio6n@ovh.net	2022-07-03	busy
481	3186	260	Jay Navadiya	 dbnavadiya@gmail.com	\N	1234
\.


--
-- TOC entry 3867 (class 0 OID 24701)
-- Dependencies: 215
-- Data for Name: government_officials; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.government_officials (official_id, location_id) FROM stdin;
241	3106
242	3108
243	3105
244	3120
245	3139
246	3118
247	3137
248	3136
249	3155
250	3149
251	3160
252	3119
253	3150
254	3152
255	3111
256	3149
257	3104
258	3134
259	3160
260	3139
261	3132
262	3101
263	3103
264	3148
265	3157
266	3107
267	3116
268	3101
269	3129
270	3117
271	3101
272	3138
273	3142
274	3135
275	3146
276	3149
277	3152
278	3142
279	3154
280	3111
281	3147
282	3121
283	3117
284	3124
285	3132
286	3103
287	3116
288	3107
289	3160
290	3116
291	3144
292	3107
293	3117
294	3121
295	3129
296	3140
297	3101
298	3115
299	3143
300	3121
\.


--
-- TOC entry 3881 (class 0 OID 24802)
-- Dependencies: 229
-- Data for Name: hires; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.hires (user_id, business_id, labor_id) FROM stdin;
27	222	62
31	220	117
13	236	98
44	233	111
17	225	82
30	218	73
26	181	61
11	206	111
32	218	109
55	200	82
47	223	105
56	218	65
4	223	76
20	224	64
19	197	83
37	210	76
50	187	115
18	205	108
56	188	108
28	219	116
33	189	107
19	212	94
14	201	63
33	222	65
58	212	74
33	206	66
35	228	65
14	192	80
18	196	101
26	209	100
46	237	114
45	218	65
39	210	73
11	188	81
12	194	96
38	187	120
58	208	113
2	226	87
50	233	86
29	197	101
3	224	117
48	209	89
11	226	85
60	218	88
13	212	78
50	237	77
35	200	89
56	225	115
18	183	61
5	181	67
32	228	68
52	190	112
43	236	75
13	226	71
45	187	75
10	185	100
52	197	83
18	186	79
51	224	98
9	230	106
\.


--
-- TOC entry 3873 (class 0 OID 24735)
-- Dependencies: 221
-- Data for Name: hourly_labors; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.hourly_labors (labor_id, hourly_wage, hours_worked) FROM stdin;
113	5	39
108	7	86
67	11	22
97	12	84
71	10	81
106	7	29
95	12	99
104	6	29
120	11	22
69	10	55
70	5	55
98	4	48
84	3	75
110	4	55
62	12	57
102	5	97
103	2	22
64	3	51
105	2	86
117	1	44
87	3	68
116	7	26
112	8	38
66	6	74
118	12	19
86	10	30
77	7	41
\.


--
-- TOC entry 3864 (class 0 OID 24680)
-- Dependencies: 212
-- Data for Name: labor; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.labor (labor_id, birth_date, work_hours, wage_remaining, rating, type_of_work, supervisor_id, supervised_since, location_id, account_number, password) FROM stdin;
61	1986-05-20	95	$35.00	1	Gardener	130	2022-03-25	3123	827356014688	labor
62	1977-09-06	57	$5.00	5	Carpenter	167	2022-08-12	3142	341357647563	labor
63	1988-03-29	62	$50.00	1	Carpenter	124	2022-07-23	3148	213792854742	labor
64	1986-12-02	51	$18.00	3	Painter	145	2022-07-31	3109	831866853300	labor
65	1984-03-09	77	$41.00	4	Housekeeper	180	2022-06-28	3148	706015395842	labor
66	1988-08-16	74	$11.00	1	Barber	159	2022-06-22	3159	771397699693	labor
67	1977-03-20	22	$31.00	3	Construction Worker	125	2022-01-25	3120	181975498102	labor
68	1991-03-17	54	$4.00	5	Carpenter	155	2022-09-22	3126	74403052323	labor
69	1964-10-16	55	$23.00	2	Plumber	148	2022-08-12	3119	520484572504	labor
70	1984-06-03	65	$48.00	5	Electrician	130	2022-08-09	3139	864319055778	labor
71	1961-05-23	81	$14.00	2	Housekeeper	164	2022-04-12	3146	542765434017	labor
72	1986-03-18	38	$24.00	2	Construction Worker	128	2022-07-22	3104	926811920358	labor
73	1984-03-16	91	$5.00	3	Painter	177	2022-09-10	3127	440630000275	labor
74	1990-03-24	46	$27.00	2	Carpenter	171	2022-08-27	3157	106796877612	labor
75	1973-03-26	34	$19.00	2	Gardener	144	2022-06-24	3144	655114191614	labor
76	1964-03-28	37	$8.00	4	Plumber	156	2022-06-24	3154	885831183161	labor
77	1986-05-02	41	$22.00	5	Carpenter	133	2022-07-10	3101	162844334608	labor
78	1960-11-01	85	$16.00	1	Gardener	137	2022-09-12	3156	711875587690	labor
79	1981-10-30	92	$41.00	2	Construction Worker	124	2022-02-15	3105	215290900210	labor
80	1984-10-08	22	$36.00	4	Barber	158	2021-12-08	3144	367823883118	labor
81	1975-07-01	65	$40.00	4	Electrician	147	2022-05-06	3147	972935202161	labor
82	1975-11-08	96	$7.00	3	Plumber	154	2022-03-23	3155	919018688186	labor
83	1965-06-15	84	$31.00	1	Carpenter	167	2022-04-04	3108	245521580923	labor
84	1984-01-15	75	$42.00	3	Gardener	178	2022-01-23	3158	790349530906	labor
85	1980-06-04	44	$39.00	5	Barber	130	2022-02-13	3159	169986888059	labor
86	1966-03-15	30	$39.00	5	Plumber	158	2022-04-27	3116	174034333510	labor
87	1983-03-21	68	$30.00	5	Gardener	135	2022-02-02	3109	242987258224	labor
88	1960-11-02	87	$12.00	2	Barber	162	2022-07-25	3125	896476066901	labor
89	1966-10-01	77	$20.00	5	Electrician	121	2022-11-02	3157	348431273747	labor
90	1961-12-14	14	$4.00	5	Carpenter	148	2022-02-26	3146	404155110275	labor
91	1975-03-26	47	$44.00	1	Gardener	122	2022-06-23	3122	940465026141	labor
92	1986-11-26	34	$29.00	1	Gardener	128	2022-05-09	3131	701973679986	labor
93	1989-03-22	32	$33.00	1	Barber	146	2022-07-25	3107	625550046533	labor
94	1973-10-26	61	$46.00	5	Carpenter	166	2022-05-20	3144	124029518183	labor
95	1974-02-13	99	$28.00	5	Gardener	141	2022-10-20	3145	343455011781	labor
96	1967-05-31	16	$27.00	5	Electrician	126	2022-06-29	3103	131331128588	labor
97	1960-09-15	84	$12.00	1	Plumber	170	2022-07-10	3116	757806640822	labor
98	1971-09-16	48	$48.00	2	Electrician	167	2022-06-16	3112	370163207306	labor
99	1982-04-06	14	$6.00	2	Carpenter	153	2022-07-14	3127	133982615930	labor
100	1964-02-21	69	$34.00	2	Barber	151	2021-12-18	3158	586590007588	labor
101	1983-01-12	18	$45.00	3	Plumber	122	2022-05-17	3114	124611301056	labor
102	1964-11-20	97	$14.00	1	Carpenter	171	2022-04-08	3145	939540852075	labor
103	1967-07-20	22	$39.00	5	Barber	157	2022-06-02	3151	577183872997	labor
104	1983-04-06	29	$48.00	2	Barber	149	2022-01-16	3146	810529517553	labor
105	1988-08-16	86	$28.00	4	Painter	152	2022-09-09	3106	31614917085	labor
106	1969-04-14	56	$11.00	2	Plumber	163	2022-04-30	3111	372984215091	labor
107	1966-07-16	38	$35.00	5	Electrician	175	2022-05-02	3103	50935258662	labor
108	1974-01-19	86	$37.00	4	Carpenter	160	2022-03-14	3123	665271732320	labor
109	1983-03-25	18	$6.00	3	Construction Worker	121	2022-08-29	3113	398508972717	labor
110	1982-07-19	55	$2.00	1	Carpenter	138	2022-11-01	3125	247491963926	labor
111	1964-07-01	68	$15.00	5	Barber	166	2022-10-06	3150	938295692024	labor
112	1976-06-12	38	$40.00	1	Housekeeper	161	2022-02-01	3113	421972594662	labor
113	1991-11-26	39	$46.00	5	Electrician	127	2021-12-25	3109	466220673016	labor
114	1970-11-07	28	$21.00	4	Construction Worker	125	2022-05-27	3118	566291743909	labor
115	1972-06-11	93	$28.00	4	Construction Worker	169	2022-08-30	3144	702076334845	labor
116	1961-06-11	26	$23.00	1	Housekeeper	124	2022-02-10	3157	856939111874	labor
117	1987-07-01	44	$21.00	4	Construction Worker	173	2022-04-15	3101	658130716774	labor
118	1983-09-06	19	$48.00	4	Barber	124	2022-08-20	3126	708116024769	labor
119	1983-05-23	58	$17.00	3	Construction Worker	138	2022-02-15	3117	991434927056	labor
120	1975-03-19	25	$8.00	4	Construction Worker	164	2022-07-04	3155	264183937513	labor
\.


--
-- TOC entry 3865 (class 0 OID 24687)
-- Dependencies: 213
-- Data for Name: labor_supervisor; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.labor_supervisor (supervisor_id, managed_since, business_id, location_id, account_number, password) FROM stdin;
121	2020-04-25	182	3138	918850167327	super
122	2020-08-29	226	3144	514123985878	super
123	2022-09-08	187	3116	833321069641	super
124	2022-05-06	189	3149	493344411423	super
125	2019-06-20	224	3132	491223410475	super
126	2021-04-17	193	3143	729147815677	super
127	2020-09-21	189	3118	848314642376	super
128	2021-12-07	187	3146	665939567382	super
129	2019-07-23	199	3139	422972110819	super
130	2022-08-09	185	3103	855382782821	super
131	2021-02-13	221	3153	310771477107	super
132	2021-07-31	208	3160	24299684311	super
133	2019-09-09	200	3148	722641505880	super
134	2021-07-26	215	3160	235176531055	super
135	2021-03-07	181	3151	230251297309	super
136	2019-11-27	223	3120	856879060417	super
137	2020-06-23	221	3145	466879496372	super
138	2021-03-25	231	3105	85848437520	super
139	2021-05-13	196	3128	145810273412	super
140	2022-11-01	226	3142	684395208302	super
141	2019-09-29	202	3160	845323419946	super
142	2020-01-03	210	3135	316169727019	super
143	2022-06-19	240	3111	899293837273	super
144	2020-09-08	235	3153	347988875692	super
145	2021-06-13	209	3117	541794237722	super
146	2022-10-24	208	3136	563192243577	super
147	2019-07-30	190	3126	513953767143	super
148	2022-01-14	187	3136	783951825379	super
149	2020-08-27	215	3120	248330950980	super
150	2022-06-08	209	3148	251176053002	super
151	2020-07-16	219	3109	818916563321	super
152	2021-08-12	199	3108	104652962105	super
153	2022-02-14	217	3128	537259753836	super
154	2020-09-15	192	3158	133233020353	super
155	2020-05-30	231	3160	399583802029	super
156	2022-01-13	191	3143	385792511123	super
157	2022-02-22	232	3146	478712518297	super
158	2022-03-09	221	3113	343333834345	super
159	2021-08-30	227	3130	970312540833	super
160	2022-01-25	225	3104	90978019034	super
161	2021-10-19	194	3137	797843958812	super
162	2020-10-28	209	3149	970447962812	super
163	2022-06-26	199	3148	313117679957	super
164	2020-04-15	219	3149	600232347547	super
165	2021-08-24	239	3157	630018021767	super
166	2022-08-10	234	3150	461278986331	super
167	2020-03-21	213	3122	748124513430	super
168	2022-03-15	189	3130	642113948110	super
169	2022-09-09	229	3128	920421015313	super
170	2019-09-01	221	3119	295846757930	super
171	2022-09-13	231	3122	843749057076	super
172	2022-01-16	229	3157	620017149865	super
173	2021-02-22	197	3153	881638162430	super
174	2019-09-03	219	3141	78251800659	super
175	2020-10-28	188	3139	7517108588	super
176	2020-03-23	189	3126	207921772999	super
177	2020-11-03	235	3111	42334705665	super
178	2022-05-13	183	3143	400569441999	super
179	2020-10-21	226	3112	863840611764	super
180	2021-12-22	184	3123	709971905203	super
421	\N	191	3181	6894077	1234
662	\N	198	3185	7775951	1234
\.


--
-- TOC entry 3875 (class 0 OID 24745)
-- Dependencies: 223
-- Data for Name: leave; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.leave (leave_id, leave_date) FROM stdin;
1	2022-08-17
2	2022-06-24
3	2022-06-07
4	2022-09-24
5	2022-07-17
6	2022-01-23
7	2022-04-10
8	2022-01-06
9	2022-07-03
10	2022-08-09
11	2022-09-29
12	2022-05-20
13	2022-10-18
14	2022-11-12
15	2022-07-21
16	2022-08-05
17	2022-07-04
18	2022-10-06
19	2022-02-23
20	2022-08-19
21	2022-03-08
22	2022-07-15
23	2022-07-05
24	2022-06-26
25	2022-08-25
26	2022-08-12
27	2022-05-12
28	2022-01-04
29	2022-03-25
30	2022-10-17
31	2022-05-29
32	2022-09-05
33	2022-08-07
34	2022-07-08
35	2022-07-13
36	2022-08-12
37	2022-05-27
38	2022-08-30
39	2022-11-07
40	2022-01-03
41	2022-02-18
42	2022-09-09
43	2022-06-13
44	2022-10-22
45	2022-08-28
46	2022-02-03
47	2021-12-22
48	2022-04-28
49	2022-01-31
50	2022-05-09
51	2022-05-13
52	2022-08-22
53	2022-11-11
54	2022-01-30
55	2022-06-25
56	2022-07-03
57	2022-02-11
58	2022-10-26
59	2022-05-30
60	2022-08-12
\.


--
-- TOC entry 3866 (class 0 OID 24694)
-- Dependencies: 214
-- Data for Name: location_info; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.location_info (location_id, city, district) FROM stdin;
3101	Yablonovskiy	Linoan
3102	Cansolungon	Wangbuzhuang
3103	Ludvika	Putinci
3104	Wudil	Melbourne
3105	Dujuuma	Lluka e Eperme
3106	Bytkiv	Santo Antônio do Monte
3107	Iperó	Klippan
3108	Yisa	Liutao
3109	Santiago do Cacém	Londiani
3110	Alannay	Agía Varvára
3111	Socorro	Dortmund
3112	Ulaan-Ereg	Santo Tomás
3113	Sarakhs	Zürich
3114	Tolosa	Yataity del Norte
3115	Sovetskiy	Përmet
3116	Ibrā’	Nizhniy Tagil
3117	Rude	Zumiao
3118	Pa Sang	Teberda
3120	Yangjingziwan	Esperanza
3121	Shijing	Makurazaki
3122	Karangbalong	Jangheung
3123	Jicun	Karangmulyo
3124	Lumbayan	Santiago de las Vegas
3125	Kochevo	Kawengan
3126	Nytva	Santos
3127	Baitu	Liloan
3128	Goworowo	Pontevedra
3129	Pithoro	Timoulilt
3130	Dailekh	Zheshan
3131	Tupiza	Namīn
3132	Ebene	Jipijapa
3133	Halden	Galtek
3134	Madala	Aleg
3135	Habingkloang	Szolnok
3136	Dolní Studénky	São Paio Merelim
3137	Ho	Pérama
3138	Zambujal	Jiangpu
3139	Chorotis	Ōnojō
3140	Palermo	Xuetian
3141	Zliv	Hovd
3142	Balite	Ramon Magsaysay
3143	Port-Gentil	Macheng
3144	Bongao	Gedongmulyo
3145	Acobamba	Elaiochóri
3146	Baitang	Taznakht
3147	Lazaro Cardenas	Kwolla
3148	Jinghong	Alilem
3149	Al ‘Āliyah	Bressuire
3150	Higashimurayama-shi	Olonets
3151	Palocabildo	Arauá
3153	Changle	Mets Parni
3155	Hongjiang	La Virtud
3156	Jiamaogong	Aykol
3157	Nantes	Borek
3158	La Unión	Juuka
3159	Stalís	Ageoshimo
3160	Alarobia	Washington
3186	  Bhavnagar	  Bhavnagar5
3152	     Zaria	     Longxian
3161	Bhavnagar	Bhavnagar
3162	Bhavnagar	Bhavnagar
3163	Bhavnagar	Bhavnagar
3164	Bhavnagar	Bhavnagar
3165	Bhavnagar	Bhavnagar
3166	Bhavnagar	Bhavnagar
3167	Bhavnagar	Bhavnagar
3168	Bhavnagar	Bhavnagar
3169	Bhavnagar	Bhavnagar
3170	Bhavnagar	Bhavnagar
3171	Bhavnagar	Bhavnagar
3172	Bhavnagar	Bhavnagar
3173	Bhavnagar	Bhavnagar
3174	Bhavnagar	Bhavnagar
3175	Bhavnagar	Bhavnagar
3176	Bhavnagar	Bhavnagar
3177	Bhavnagar	Bhavnagar
3178	Bhavnagar	Bhavnagar
3179	Bhavnagar	Bhavnagar
3180	Bhavnagar	Bhavnagar
3181	Bhavnagar	Bhavnagar
3182	Bhavnagar	Bhavnagar
3183	Bhavnagar	Bhavnagar
3184	Bhavnagar	Bhavnagar
3119	 Krasiczyn	 Riihimäkigg
3185	        Bhavnagar	        Bhavnagar14
3154	    Padana	    Constanza
\.


--
-- TOC entry 3870 (class 0 OID 24718)
-- Dependencies: 218
-- Data for Name: payment_info; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.payment_info (payment_number, payment_id, paid_for_byhours, amount_paid, date) FROM stdin;
1	85781	29	674	2022-11-13
2	79743	69	708	2022-02-21
3	29605	65	871	2022-03-23
4	57911	85	855	2022-10-16
5	59755	57	982	2021-12-28
6	21827	99	827	2022-08-21
7	93752	22	951	2022-01-24
8	65050	22	530	2022-04-01
9	57619	93	801	2022-03-05
10	25630	48	629	2022-10-19
11	51848	65	914	2022-07-22
12	23624	46	564	2022-07-10
13	24622	96	539	2021-12-05
14	68044	14	929	2022-01-21
15	84892	54	524	2022-03-08
16	80234	29	872	2022-08-24
17	47315	97	948	2022-09-19
18	59147	86	657	2022-01-10
19	81049	44	755	2022-02-01
20	19855	87	412	2022-04-15
21	24712	68	735	2022-07-02
22	31899	46	989	2022-07-02
23	38098	16	973	2022-01-24
24	92876	95	627	2022-09-09
25	94781	95	523	2022-03-07
26	31470	54	957	2021-12-20
27	20433	56	928	2022-02-22
28	79702	86	647	2022-09-03
29	29409	58	856	2022-06-19
30	94299	29	536	2022-10-19
31	47871	37	947	2022-01-03
32	99012	32	689	2022-06-10
33	75566	65	459	2022-05-17
34	18852	86	962	2022-09-21
35	36598	51	965	2022-10-22
36	76481	47	467	2022-04-07
37	15049	68	638	2022-03-06
38	15400	65	495	2021-11-30
39	28302	51	616	2021-11-17
40	23696	92	671	2022-11-07
41	51393	14	514	2021-11-18
42	81522	51	909	2022-04-11
43	62933	68	575	2022-03-18
44	47667	55	719	2022-09-07
45	52740	75	547	2022-09-20
46	52961	37	787	2022-06-28
47	73653	34	656	2022-06-27
48	21792	38	845	2021-11-15
49	13914	44	466	2022-04-13
50	38509	92	755	2021-12-21
51	36418	38	706	2022-03-18
52	86665	28	577	2022-09-09
53	54140	68	561	2022-07-18
54	87810	84	577	2021-12-11
55	66732	48	652	2021-12-11
56	12146	91	872	2022-01-21
57	89224	55	440	2022-08-10
58	32516	38	460	2022-07-31
59	21721	34	405	2022-09-19
60	23773	25	854	2022-02-04
\.


--
-- TOC entry 3878 (class 0 OID 24776)
-- Dependencies: 226
-- Data for Name: pays; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.pays (supervisor_id, labor_id, payment_number, user_id) FROM stdin;
165	75	1	27
132	65	2	57
169	110	3	11
129	69	4	29
168	61	5	58
180	77	6	2
150	117	7	22
151	67	8	1
161	86	9	5
176	88	10	2
143	115	11	56
154	71	12	51
122	62	13	27
163	65	14	32
123	112	15	6
134	114	16	22
175	93	17	2
141	67	18	48
134	83	19	6
162	76	20	27
132	77	21	48
170	75	22	51
128	95	23	21
131	109	24	3
165	107	25	22
131	85	26	11
145	94	27	45
149	88	28	52
131	113	29	25
143	93	30	31
158	102	31	49
146	114	32	33
171	71	33	4
160	82	34	49
159	91	35	34
174	90	36	51
130	120	37	36
143	95	38	8
157	61	39	13
165	119	40	16
174	82	41	55
142	86	42	59
171	86	43	42
126	120	44	58
129	82	45	44
122	65	46	3
135	109	47	26
180	106	48	48
124	118	49	55
136	102	50	60
143	70	51	42
144	112	52	8
161	113	53	32
123	72	54	12
151	79	55	10
141	80	56	44
166	118	57	46
158	70	58	57
177	68	59	24
155	97	60	22
\.


--
-- TOC entry 3884 (class 0 OID 24822)
-- Dependencies: 232
-- Data for Name: personal_info; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.personal_info (user_id, labor_id, supervisor_id, official_id, mobile_number, type_of_user, name, email) FROM stdin;
2	\N	\N	\N	8055157589	user	Gabbi Yeardley	gyeardley1@slashdot.org
3	\N	\N	\N	8358386732	user	Maren Branford	mbranford2@google.com.br
4	\N	\N	\N	346200409	user	Marven Sissland	msissland3@amazon.com
5	\N	\N	\N	5229203792	user	Camila Buttler	cbuttler4@usa.gov
6	\N	\N	\N	4728880509	user	Madeline Pomphrett	mpomphrett5@bloglovin.com
7	\N	\N	\N	7752229709	user	Bradan Wickham	bwickham6@webnode.com
8	\N	\N	\N	9962022911	user	Candide Prosch	cprosch7@geocities.jp
9	\N	\N	\N	6588214596	user	Adrien Danes	adanes8@cbsnews.com
10	\N	\N	\N	2922166951	user	Ingeborg Murdoch	imurdoch9@nifty.com
11	\N	\N	\N	4644975144	user	Domenico Sherbrook	dsherbrooka@noaa.gov
12	\N	\N	\N	1587651787	user	Lilias Confait	lconfaitb@google.de
13	\N	\N	\N	1569402053	user	Gaspar Davis	gdavisc@altervista.org
14	\N	\N	\N	7934460030	user	Matti Luton	mlutond@cmu.edu
15	\N	\N	\N	8265048110	user	Hughie Curnnok	hcurnnoke@booking.com
16	\N	\N	\N	6331934716	user	Aldin Greenhalgh	agreenhalghf@statcounter.com
17	\N	\N	\N	8817052707	user	Ben Schimpke	bschimpkeg@statcounter.com
18	\N	\N	\N	894566101	user	Dru Giffaut	dgiffauth@wisc.edu
19	\N	\N	\N	960289850	user	Granny Peterkin	gpeterkini@gmpg.org
20	\N	\N	\N	8872615835	user	Gothart O'Keevan	gokeevanj@cbc.ca
21	\N	\N	\N	19196628	user	Barbi Knapper	bknapperk@freewebs.com
22	\N	\N	\N	7844217276	user	Christine Beckenham	cbeckenhaml@creativecommons.org
23	\N	\N	\N	3735511865	user	Emmalyn Le Grand	elem@hibu.com
24	\N	\N	\N	9840364548	user	Berti Muzzini	bmuzzinin@mediafire.com
25	\N	\N	\N	2369164427	user	Rheta Jenken	rjenkeno@pagesperso-orange.fr
26	\N	\N	\N	5369916083	user	Montgomery Wride	mwridep@fda.gov
27	\N	\N	\N	9120402488	user	Desmond Godbehere	dgodbehereq@jiathis.com
28	\N	\N	\N	6366223283	user	Evvy Bennis	ebennisr@cisco.com
29	\N	\N	\N	6810924926	user	Katya Bruhnicke	kbruhnickes@uiuc.edu
30	\N	\N	\N	580140490	user	Nanni Collcutt	ncollcuttt@mapquest.com
31	\N	\N	\N	6048132896	user	Ester O'Hederscoll	eohederscollu@pagesperso-orange.fr
32	\N	\N	\N	8018110836	user	Ursa Robardley	urobardleyv@smh.com.au
33	\N	\N	\N	3306393503	user	Rickie Kelland	rkellandw@washington.edu
34	\N	\N	\N	5577504233	user	Julissa Muscat	jmuscatx@free.fr
35	\N	\N	\N	2929809569	user	Billye Vairow	bvairowy@360.cn
36	\N	\N	\N	51888964	user	Lane Puckrin	lpuckrinz@wordpress.com
37	\N	\N	\N	4836973398	user	Torrin Cleugh	tcleugh10@reverbnation.com
38	\N	\N	\N	3030979912	user	Sydel Perford	sperford11@time.com
39	\N	\N	\N	1971300481	user	Rollie Goodwill	rgoodwill12@pinterest.com
40	\N	\N	\N	5325216992	user	Ludwig Royston	lroyston13@weather.com
41	\N	\N	\N	3440013433	user	Vinnie Southey	vsouthey14@bing.com
42	\N	\N	\N	1195962842	user	Edee Tukely	etukely15@hexun.com
43	\N	\N	\N	2501840297	user	Minny Chetwin	mchetwin16@economist.com
44	\N	\N	\N	4179523937	user	Cornela Feaveryear	cfeaveryear17@cdbaby.com
45	\N	\N	\N	7626992473	user	Dorree Ferenczy	dferenczy18@google.it
46	\N	\N	\N	3153438325	user	Tracie Jehaes	tjehaes19@ehow.com
47	\N	\N	\N	3358283311	user	Blane Masterson	bmasterson1a@amazon.co.uk
48	\N	\N	\N	642488843	user	Verena Gibbeson	vgibbeson1b@pcworld.com
49	\N	\N	\N	2285072533	user	Ginny Mooney	gmooney1c@dailymail.co.uk
50	\N	\N	\N	33884471	user	Sawyer Sandcroft	ssandcroft1d@bravesites.com
51	\N	\N	\N	8971224913	user	Andrej Riglesford	ariglesford1e@exblog.jp
52	\N	\N	\N	2332487725	user	Chet O' Borne	co1f@arizona.edu
53	\N	\N	\N	6511502661	user	Armin Heinschke	aheinschke1g@sbwire.com
54	\N	\N	\N	9465288590	user	Bern Elix	belix1h@desdev.cn
55	\N	\N	\N	7690931006	user	Malinde Chark	mchark1i@yellowbook.com
56	\N	\N	\N	1631299660	user	Burnaby Cowle	bcowle1j@umn.edu
57	\N	\N	\N	3914653317	user	Becka St. Clair	bst1k@hostgator.com
58	\N	\N	\N	6271423015	user	Marijn Chappel	mchappel1l@ox.ac.uk
59	\N	\N	\N	7694003635	user	Angel Steptowe	asteptowe1m@tinypic.com
\N	61	\N	\N	7513474225	labor	Elsa Yardley	eyardley1o@imdb.com
\N	62	\N	\N	7939582047	labor	Dougie Georgeson	dgeorgeson1p@walmart.com
\N	63	\N	\N	1142991153	labor	Janaye Sealey	jsealey1q@joomla.org
\N	64	\N	\N	4809634377	labor	Othilia Firman	ofirman1r@stumbleupon.com
\N	65	\N	\N	519764431	labor	Hirsch Charlotte	hcharlotte1s@sciencedirect.com
\N	66	\N	\N	4784976207	labor	Elbertina Dulake	edulake1t@pen.io
\N	67	\N	\N	4486076001	labor	Estel Hartill	ehartill1u@issuu.com
\N	68	\N	\N	6746570411	labor	Sargent Plackstone	splackstone1v@skyrock.com
\N	69	\N	\N	4890694865	labor	Dian Dmiterko	ddmiterko1w@biblegateway.com
\N	70	\N	\N	4896981443	labor	Lexine Ganter	lganter1x@deliciousdays.com
\N	71	\N	\N	803564455	labor	Bernardina Sidsaff	bsidsaff1y@sun.com
\N	72	\N	\N	9155558851	labor	Jacinta Giffin	jgiffin1z@mapquest.com
\N	73	\N	\N	39498066	labor	Jori Ogglebie	jogglebie20@deviantart.com
\N	74	\N	\N	4229203978	labor	Ora Weddell	oweddell21@omniture.com
\N	75	\N	\N	9825947825	labor	Bordy Baty	bbaty22@java.com
\N	76	\N	\N	4825076696	labor	Sheffie Jebb	sjebb23@tumblr.com
\N	77	\N	\N	5752848565	labor	Trumann May	tmay24@microsoft.com
\N	78	\N	\N	5073871615	labor	Timmi Kleynen	tkleynen25@cam.ac.uk
\N	79	\N	\N	4775428569	labor	Haley Sandels	hsandels26@last.fm
\N	80	\N	\N	3501934015	labor	Kakalina Adshad	kadshad27@cyberchimps.com
\N	81	\N	\N	9661384620	labor	Carlotta Date	cdate28@ucoz.ru
\N	82	\N	\N	5842729466	labor	Garwood Jellard	gjellard29@weebly.com
\N	83	\N	\N	8798914678	labor	Mureil Ballard	mballard2a@businessweek.com
\N	84	\N	\N	7329858879	labor	Quentin Pheazey	qpheazey2b@wiley.com
\N	85	\N	\N	468364459	labor	Stewart Tourmell	stourmell2c@usnews.com
\N	86	\N	\N	1007934647	labor	Lorrin Ourry	lourry2d@prlog.org
\N	87	\N	\N	8491450175	labor	Nanette Smethurst	nsmethurst2e@sfgate.com
\N	88	\N	\N	9604638624	labor	Coleman Lindelof	clindelof2f@etsy.com
\N	89	\N	\N	3332539870	labor	Bethany Angrave	bangrave2g@yale.edu
\N	90	\N	\N	4762342913	labor	Nadine Raincin	nraincin2h@sourceforge.net
\N	91	\N	\N	1941238697	labor	Prince Courtliff	pcourtliff2i@unesco.org
\N	92	\N	\N	810797813	labor	Libby Glyne	lglyne2j@sitemeter.com
\N	93	\N	\N	7083632362	labor	Christean Mabon	cmabon2k@bigcartel.com
\N	94	\N	\N	2073067922	labor	Eleanor Culverhouse	eculverhouse2l@cnn.com
\N	95	\N	\N	9483556851	labor	Efren Oldnall	eoldnall2m@discovery.com
\N	96	\N	\N	3442979483	labor	Bastian Lowthorpe	blowthorpe2n@alibaba.com
\N	97	\N	\N	2317100681	labor	Franky Spooner	fspooner2o@yelp.com
\N	98	\N	\N	7505774914	labor	Freida Arkil	farkil2p@icq.com
\N	99	\N	\N	1902045935	labor	Konstance Casterton	kcasterton2q@domainmarket.com
\N	100	\N	\N	2412463659	labor	Cristi Emma	cemma2r@gravatar.com
\N	101	\N	\N	2371583034	labor	Meredith Kaszper	mkaszper2s@unblog.fr
\N	102	\N	\N	5469467015	labor	Vicki Vanne	vvanne2t@diigo.com
\N	103	\N	\N	5343081842	labor	Evyn Langtree	elangtree2u@japanpost.jp
\N	104	\N	\N	6596141639	labor	Stanislaus Eagle	seagle2v@earthlink.net
\N	105	\N	\N	7113664705	labor	Rene McQuaid	rmcquaid2w@hibu.com
\N	106	\N	\N	9607446522	labor	Manny Goode	mgoode2x@miibeian.gov.cn
\N	107	\N	\N	37270326	labor	Quintus Ellerington	qellerington2y@irs.gov
\N	108	\N	\N	4023722856	labor	Christan Bennetto	cbennetto2z@reddit.com
\N	109	\N	\N	4736066685	labor	Chic Bottini	cbottini30@gmpg.org
\N	110	\N	\N	41817269	labor	Charisse Axleby	caxleby31@twitpic.com
\N	111	\N	\N	9878026728	labor	Arvy Coggill	acoggill32@chicagotribune.com
\N	112	\N	\N	9454979090	labor	Saba Quinet	squinet33@google.com.br
\N	113	\N	\N	7942204850	labor	Dacy Ineson	dineson34@shutterfly.com
\N	114	\N	\N	6496700341	labor	Karla Craighill	kcraighill35@youtube.com
\N	115	\N	\N	6857255681	labor	Guntar Aronstam	garonstam36@cargocollective.com
\N	116	\N	\N	7458398546	labor	Monro Brownsworth	mbrownsworth37@xrea.com
\N	117	\N	\N	7521211696	labor	Nara Bernardoux	nbernardoux38@ucoz.com
\N	118	\N	\N	4588320277	labor	Robyn Bazoche	rbazoche39@plala.or.jp
\N	119	\N	\N	954584157	labor	Lynea Bradbury	lbradbury3a@wordpress.com
\N	120	\N	\N	6249077072	labor	Selena Geoghegan	sgeoghegan3b@hugedomains.com
\N	\N	121	\N	4536568671	supervisor	Merola Morales	mmorales3c@51.la
\N	\N	122	\N	5815816688	supervisor	Chester Tims	ctims3d@nbcnews.com
\N	\N	123	\N	6571187331	supervisor	Mallorie Grzes	mgrzes3e@mediafire.com
\N	\N	124	\N	1582644650	supervisor	Amie Redholes	aredholes3f@eventbrite.com
\N	\N	125	\N	5888758820	supervisor	Avril Ninnoli	aninnoli3g@studiopress.com
\N	\N	126	\N	7077073996	supervisor	Aprilette Lantoph	alantoph3h@psu.edu
\N	\N	127	\N	8826757125	supervisor	Gabrielle Slide	gslide3i@tamu.edu
\N	\N	128	\N	3111249986	supervisor	Roxi Gilchrist	rgilchrist3j@bandcamp.com
\N	\N	129	\N	3154191196	supervisor	Jacob Kubica	jkubica3k@redcross.org
\N	\N	130	\N	1860843469	supervisor	Alejandro Messier	amessier3l@kickstarter.com
\N	\N	131	\N	7591034130	supervisor	Dallas Crocetto	dcrocetto3m@istockphoto.com
\N	\N	132	\N	641542335	supervisor	Gawen McCullouch	gmccullouch3n@phpbb.com
\N	\N	133	\N	8724289569	supervisor	Vanya Ragless	vragless3o@domainmarket.com
\N	\N	134	\N	2559648391	supervisor	Danya Shasnan	dshasnan3p@mozilla.org
\N	\N	135	\N	8852775759	supervisor	Willi Pedley	wpedley3q@google.de
\N	\N	136	\N	8306812239	supervisor	Nichol Chatfield	nchatfield3r@imageshack.us
\N	\N	137	\N	5384855121	supervisor	Stephi Hobble	shobble3s@wsj.com
\N	\N	138	\N	5173372575	supervisor	Harriette Burniston	hburniston3t@uiuc.edu
\N	\N	139	\N	7684790575	supervisor	Nikki Gerritzen	ngerritzen3u@diigo.com
\N	\N	140	\N	4927896170	supervisor	Trude Husthwaite	thusthwaite3v@wiley.com
\N	\N	141	\N	2935890597	supervisor	Shanan Freer	sfreer3w@oakley.com
\N	\N	142	\N	2730123176	supervisor	Brnaba Poff	bpoff3x@sciencedirect.com
\N	\N	143	\N	6304244562	supervisor	Vince Faire	vfaire3y@google.co.uk
\N	\N	144	\N	8406872297	supervisor	Auroora Lupson	alupson3z@mysql.com
\N	\N	145	\N	5826226275	supervisor	Byran Canete	bcanete40@scientificamerican.com
\N	\N	146	\N	9218515580	supervisor	Laird Pywell	lpywell41@multiply.com
\N	\N	147	\N	3878916826	supervisor	Esther Sehorsch	esehorsch42@microsoft.com
\N	\N	148	\N	7887054919	supervisor	Aleta Bendix	abendix43@nsw.gov.au
\N	\N	149	\N	765953904	supervisor	Bron Simonou	bsimonou44@imdb.com
\N	\N	150	\N	2556498735	supervisor	Edsel Kenafaque	ekenafaque45@ameblo.jp
\N	\N	151	\N	7445033627	supervisor	Andonis Grece	agrece46@state.tx.us
\N	\N	152	\N	8820840034	supervisor	Eryn Turvie	eturvie47@twitpic.com
\N	\N	153	\N	1128633950	supervisor	Doretta Axtell	daxtell48@deviantart.com
\N	\N	154	\N	7128638797	supervisor	Carmon Payn	cpayn49@weather.com
\N	\N	155	\N	8942969738	supervisor	Mitchel Perutto	mperutto4a@constantcontact.com
\N	\N	156	\N	7824766943	supervisor	Yvonne Ruppelin	yruppelin4b@storify.com
\N	\N	157	\N	8603012047	supervisor	Xenia Slopier	xslopier4c@loc.gov
\N	\N	158	\N	9613053168	supervisor	Tabbie Ligoe	tligoe4d@businessinsider.com
\N	\N	159	\N	7828044799	supervisor	Tiffy Rivers	trivers4e@sphinn.com
\N	\N	160	\N	334393322	supervisor	Judon Hasel	jhasel4f@amazon.co.uk
\N	\N	161	\N	1897429650	supervisor	Mavra Giacomuzzo	mgiacomuzzo4g@latimes.com
\N	\N	162	\N	3955113228	supervisor	Bab Banton	bbanton4h@china.com.cn
\N	\N	163	\N	7053268812	supervisor	Brewster Dionisi	bdionisi4i@digg.com
\N	\N	164	\N	8000433586	supervisor	Veronike Riglesford	vriglesford4j@mashable.com
\N	\N	165	\N	3800511652	supervisor	Man Sill	msill4k@miibeian.gov.cn
\N	\N	166	\N	3730212060	supervisor	Vivianna Tredger	vtredger4l@washington.edu
\N	\N	167	\N	9716305909	supervisor	Stuart Venners	svenners4m@walmart.com
\N	\N	168	\N	509126672	supervisor	Samson Amphlett	samphlett4n@fda.gov
\N	\N	169	\N	9290088924	supervisor	Gustav Causley	gcausley4o@devhub.com
\N	\N	170	\N	1222090607	supervisor	Hermy Cargen	hcargen4p@about.com
\N	\N	171	\N	5192116561	supervisor	Randie Robbe	rrobbe4q@ebay.co.uk
\N	\N	172	\N	6038545941	supervisor	Waldon Arlott	warlott4r@addthis.com
\N	\N	173	\N	9354019786	supervisor	Sara-ann Filtness	sfiltness4s@ask.com
\N	\N	174	\N	5827262237	supervisor	Emelyne Mathy	emathy4t@posterous.com
\N	\N	175	\N	5719020109	supervisor	Briano Heiner	bheiner4u@pen.io
\N	\N	176	\N	6624780139	supervisor	Jobi Keith	jkeith4v@barnesandnoble.com
\N	\N	177	\N	8007845680	supervisor	Troy Cowles	tcowles4w@posterous.com
\N	\N	178	\N	948682628	supervisor	Jakie Cappineer	jcappineer4x@cbsnews.com
\N	\N	179	\N	1692086685	supervisor	Vic Maypes	vmaypes4y@cafepress.com
\N	\N	180	\N	147421009	supervisor	Gerianne Leask	gleask4z@shinystat.com
\N	\N	\N	241	1074838586	official	Desdemona Hannen	dhannen6o@vimeo.com
\N	\N	\N	242	8358555126	official	Tuckie Moyce	tmoyce6p@skype.com
\N	\N	\N	243	1006672667	official	Lenka Honeyghan	lhoneyghan6q@exblog.jp
\N	\N	\N	244	8755661244	official	Claudell Skill	cskill6r@wufoo.com
\N	\N	\N	245	390192615	official	Maurice Lynas	mlynas6s@springer.com
\N	\N	\N	246	4524837096	official	Bridgette Andino	bandino6t@artisteer.com
\N	\N	\N	247	6841855687	official	Isidoro Ryce	iryce6u@a8.net
\N	\N	\N	248	2910658725	official	Latisha Seefeldt	lseefeldt6v@webeden.co.uk
\N	\N	\N	249	2404331212	official	Celka Sloyan	csloyan6w@1und1.de
\N	\N	\N	250	2939312006	official	Chere Weathers	cweathers6x@wsj.com
\N	\N	\N	251	6372426697	official	Maxim Nerger	mnerger6y@dion.ne.jp
\N	\N	\N	252	9345429630	official	Florry Tawton	ftawton6z@g.co
\N	\N	\N	253	4262352256	official	Hube Nelissen	hnelissen70@list-manage.com
\N	\N	\N	254	1853827736	official	Maressa Hawkett	mhawkett71@samsung.com
\N	\N	\N	255	8928076472	official	Aeriell Orchart	aorchart72@reuters.com
\N	\N	\N	256	7132874411	official	Felicle Jenyns	fjenyns73@abc.net.au
\N	\N	\N	257	1478100849	official	Pancho Trim	ptrim74@flavors.me
\N	\N	\N	258	1961063691	official	Wally Danaher	wdanaher75@google.ca
\N	\N	\N	259	5223197145	official	Larry Alp	lalp76@noaa.gov
\N	\N	\N	260	2539231276	official	Ivar Hurring	ihurring77@discuz.net
\N	\N	\N	261	1699728106	official	Akim Meeus	ameeus78@blogs.com
\N	\N	\N	262	4172325551	official	Ginni Nichol	gnichol79@dedecms.com
\N	\N	\N	263	111404721	official	Frannie Banes	fbanes7a@yolasite.com
\N	\N	\N	264	9285297002	official	Minette Storch	mstorch7b@t-online.de
\N	\N	\N	265	8917231109	official	Esta McLay	emclay7c@merriam-webster.com
\N	\N	\N	266	4692930002	official	Devondra Rubury	drubury7d@eepurl.com
\N	\N	\N	267	9037943458	official	Boycie Hane	bhane7e@aboutads.info
\N	\N	\N	268	6843354812	official	Terrance Essex	tessex7f@cbc.ca
\N	\N	\N	269	1967198577	official	Becky Sallans	bsallans7g@wp.com
\N	\N	\N	270	6222513323	official	Ellene Doxsey	edoxsey7h@wufoo.com
\N	\N	\N	271	690366863	official	Sukey Rolance	srolance7i@wordpress.com
\N	\N	\N	272	8014547087	official	Christiana Leng	cleng7j@webmd.com
\N	\N	\N	273	1600108404	official	Sheff Gilcrist	sgilcrist7k@ft.com
\N	\N	\N	274	6623235027	official	Kris Szymaniak	kszymaniak7l@twitpic.com
\N	\N	\N	275	4731211300	official	Lorain Rulten	lrulten7m@netvibes.com
\N	\N	\N	276	280783311	official	Star Sambells	ssambells7n@xinhuanet.com
\N	\N	\N	277	539441257	official	Tadeo Burgoyne	tburgoyne7o@vimeo.com
\N	\N	\N	278	8653493294	official	Kassandra McClaurie	kmcclaurie7p@meetup.com
\N	\N	\N	279	4154595042	official	Karina Woolbrook	kwoolbrook7q@moonfruit.com
\N	\N	\N	280	4085404681	official	Alix Skains	askains7r@elegantthemes.com
\N	\N	\N	281	9392448128	official	Ettore Snelgar	esnelgar7s@thetimes.co.uk
\N	\N	\N	282	8734965986	official	Viviene Casterton	vcasterton7t@foxnews.com
\N	\N	\N	283	7005057093	official	Rudolfo Blooman	rblooman7u@stumbleupon.com
\N	\N	\N	284	4957065205	official	Deny Welds	dwelds7v@mail.ru
\N	\N	\N	285	7251504177	official	Myrvyn Yackiminie	myackiminie7w@jigsy.com
\N	\N	\N	286	5564672071	official	Tally Mellor	tmellor7x@nyu.edu
\N	\N	\N	287	9747882429	official	Brady McKeighan	bmckeighan7y@yolasite.com
\N	\N	\N	288	8291303552	official	Kristel Norvell	knorvell7z@home.pl
\N	\N	\N	289	4421941146	official	Maurise Pinock	mpinock80@hhs.gov
\N	\N	\N	290	6380118173	official	Perla Cannop	pcannop81@google.es
\N	\N	\N	291	2801037836	official	Filia Carah	fcarah82@sitemeter.com
\N	\N	\N	292	7865115645	official	Fredra Livard	flivard83@telegraph.co.uk
\N	\N	\N	293	4209162375	official	Leo Floyed	lfloyed84@digg.com
\N	\N	\N	294	6909613014	official	Olympe Lovegrove	olovegrove85@bbc.co.uk
\N	\N	\N	295	939716735	official	Mattheus Duesberry	mduesberry86@toplist.cz
\N	\N	\N	296	2167392724	official	Lani Heintze	lheintze87@ask.com
\N	\N	\N	297	626575981	official	Anett Bertson	abertson88@bluehost.com
\N	\N	\N	298	7645453986	official	Niki Mallabund	nmallabund89@ocn.ne.jp
\N	\N	\N	299	482809525	official	Doretta Caney	dcaney8a@bloglines.com
\N	\N	\N	300	8441013008	official	Querida Mendenhall	qmendenhall8b@utexas.edu
1	\N	\N	\N	8101602156	user	Danni Symondson	    dsymondson0@slate.com
60	\N	\N	\N	7346633003	user	Carney Mardee	    cmardee1n@seattletimes.com
\.


--
-- TOC entry 3871 (class 0 OID 24725)
-- Dependencies: 219
-- Data for Name: schedule_info; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.schedule_info (schedule_id, entry_time, exit_time, date) FROM stdin;
1	11:16:00	16:40:00	2022-10-21
2	14:43:00	20:06:00	2022-05-28
3	09:55:00	16:38:00	2022-09-07
4	11:01:00	19:41:00	2022-01-11
5	14:43:00	18:43:00	2022-01-03
6	11:10:00	18:49:00	2022-05-08
7	13:33:00	16:24:00	2022-01-20
8	10:35:00	20:35:00	2022-01-29
9	17:12:00	19:42:00	2021-12-27
10	14:16:00	19:32:00	2022-11-09
11	13:01:00	20:29:00	2022-08-19
12	14:12:00	18:17:00	2022-08-25
13	14:35:00	18:55:00	2022-04-10
14	13:48:00	19:46:00	2022-05-31
15	07:23:00	15:20:00	2022-07-27
16	17:18:00	15:51:00	2022-03-01
17	12:51:00	15:59:00	2022-06-14
18	12:43:00	19:29:00	2021-12-26
19	06:38:00	17:42:00	2022-01-08
20	07:44:00	19:55:00	2022-04-05
21	15:17:00	20:52:00	2022-11-12
22	11:03:00	16:59:00	2022-10-25
23	07:05:00	16:13:00	2022-08-16
24	10:53:00	17:38:00	2022-10-01
25	12:36:00	16:02:00	2022-01-08
26	11:34:00	17:39:00	2022-06-25
27	11:50:00	15:50:00	2022-08-15
28	17:29:00	17:10:00	2022-09-08
29	06:49:00	15:44:00	2022-03-22
30	06:54:00	16:56:00	2022-06-25
31	09:12:00	19:46:00	2022-02-03
32	10:20:00	18:19:00	2022-07-28
33	07:17:00	18:17:00	2022-09-10
34	15:58:00	17:54:00	2022-06-14
35	12:15:00	19:19:00	2022-09-05
36	16:48:00	18:31:00	2022-09-14
37	14:10:00	15:03:00	2022-08-27
38	12:23:00	16:06:00	2022-07-17
39	14:20:00	18:38:00	2022-04-29
40	16:06:00	18:56:00	2022-08-30
41	06:23:00	17:09:00	2022-11-05
42	08:08:00	15:07:00	2022-02-12
43	17:35:00	17:14:00	2022-10-20
44	09:48:00	19:10:00	2022-09-29
45	09:40:00	18:21:00	2022-11-03
46	07:26:00	18:28:00	2022-10-01
47	13:05:00	18:52:00	2022-06-12
48	08:40:00	17:38:00	2022-10-19
49	14:09:00	15:05:00	2021-12-23
50	10:16:00	20:47:00	2022-02-22
51	17:35:00	15:43:00	2022-01-01
52	15:56:00	14:51:00	2022-07-22
53	11:50:00	17:08:00	2022-07-25
54	12:14:00	20:32:00	2022-11-02
55	12:44:00	17:25:00	2022-05-15
56	15:32:00	18:11:00	2022-07-18
57	07:21:00	16:11:00	2022-05-15
58	13:10:00	17:11:00	2022-08-12
59	08:45:00	20:03:00	2022-10-19
60	13:55:00	16:49:00	2022-03-01
\.


--
-- TOC entry 3882 (class 0 OID 24807)
-- Dependencies: 230
-- Data for Name: schedules; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.schedules (user_id, supervisor_id, labor_id, schedule_id) FROM stdin;
47	154	87	1
5	180	91	2
33	135	111	3
38	177	105	4
11	124	116	5
53	123	85	6
33	145	120	7
56	174	85	8
10	161	66	9
31	168	107	10
28	123	92	11
26	146	93	12
45	135	85	13
4	156	90	14
39	179	114	15
6	142	63	16
44	147	93	17
59	139	82	18
42	131	98	19
31	157	62	20
8	140	111	21
48	169	85	22
40	130	62	23
31	142	105	24
30	138	81	25
35	130	77	26
26	179	90	27
31	151	94	28
22	166	110	29
5	162	113	30
3	160	119	31
53	121	116	32
19	159	69	33
46	134	77	34
45	133	64	35
49	125	70	36
35	171	68	37
28	152	107	38
42	123	87	39
12	179	79	40
55	140	109	41
38	176	115	42
16	162	97	43
28	123	65	44
32	178	61	45
42	141	109	46
53	129	103	47
12	160	69	48
47	141	108	49
39	144	68	50
53	137	64	51
34	153	119	52
35	150	87	53
56	174	68	54
16	153	103	55
4	126	79	56
27	122	69	57
51	137	97	58
12	154	65	59
57	136	117	60
\.


--
-- TOC entry 3883 (class 0 OID 24817)
-- Dependencies: 231
-- Data for Name: supervisor_manager; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.supervisor_manager (lowerlevel_supervisor_id, manager_id, supervised_since) FROM stdin;
152	177	2022-03-15
177	180	2022-08-11
122	131	2022-04-29
140	158	2022-05-11
180	170	2022-05-25
\.


--
-- TOC entry 3880 (class 0 OID 24794)
-- Dependencies: 228
-- Data for Name: takes_leave; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.takes_leave (user_id, leave_id, supervisor_id, labor_id) FROM stdin;
31	1	128	119
58	2	140	62
16	3	125	75
44	4	138	97
21	5	139	76
31	6	141	65
41	7	155	86
39	8	180	73
20	9	130	66
49	10	175	85
27	11	143	98
33	12	172	119
54	13	163	107
14	14	169	61
4	15	132	79
37	16	152	62
10	17	148	115
29	18	140	98
30	19	155	88
2	20	142	82
57	21	121	73
33	22	138	68
59	23	125	99
56	24	162	119
12	25	132	106
54	26	133	114
35	27	136	93
51	28	131	66
23	29	157	117
16	30	138	89
23	31	164	85
47	32	175	109
46	33	133	70
60	34	132	120
58	35	176	82
8	36	135	116
45	37	137	65
36	38	169	83
27	39	144	70
15	40	121	111
5	41	134	103
36	42	127	104
51	43	128	89
13	44	147	94
17	45	157	97
10	46	149	74
25	47	128	73
51	48	161	109
58	49	145	64
55	50	174	111
11	51	144	117
4	52	179	99
24	53	146	93
7	54	135	83
7	55	125	68
1	56	147	94
59	57	163	84
6	58	140	83
4	59	147	105
17	60	149	94
\.


--
-- TOC entry 3876 (class 0 OID 24750)
-- Dependencies: 224
-- Data for Name: upi_info; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.upi_info (account_number, upi_id) FROM stdin;
298537795750	8388090075clwsmu
544028694207	6162911565szbcti
148456509144	4209534131cownvq
867476259	2382901375segjun
233313250426	9318509483fymhkf
883007249600	0353333811dhtdrm
498375389985	2602867590vuoyys
488790545998	5851926304dqchzy
150860783048	5270362494wianrh
400874478344	4996551366pagnpo
505389934545	2339024604cxiclm
267908092820	9974506287iafmlj
457324950031	1615730494qykpkd
57934205593	2686596015ttqgen
79193647990	9249071265xubkpx
922549739503	0077703319tjfpkd
7279396949	1711923191tnxczb
59403621618	7360682193lpootr
286872016277	2234057910wninoe
602207375039	6373805800sdxbcr
745530669069	0688608225yjubpa
281926212676	2907122207hrwtjn
536261097680	5915120214otfcie
988311223619	0835442927wyjzkd
437664978879	2734440881mfbndj
422675107573	5624115245frjsqk
194929388861	8401321938qxdkmm
190089261235	1796820893wglluf
69043981780	3413847878lboxsg
193773072455	3967686205socrzh
45623858856	7761473671pjhrni
439636251061	3620707827vkfhen
336694836748	6070901616luoklp
60123553127	3268559048sxyzqp
515207506316	0885154820dnwmor
765505520522	2950335723ylbces
203086398419	6572175529scoqvp
99628626956	8445779893sxoazz
112579839396	5778102299pzdrli
953793373891	1088639817zvujas
689751141287	9837055214hnmzxv
492640285296	6435842422nmltfy
173201091568	3079326226vrcasq
377837514449	9923956583dqfvuc
639707715022	6765943485grmjod
831174199569	9584621696emytip
202782406327	8102309066sdfcrx
786203278848	9702636193hznmqa
327456736580	8820810105talmsg
600965665889	3800139800atrwmf
92162256478	6103757626gcxebg
944476330220	0002189638rxjtee
399476342513	6265919021hxplil
467579895000	4993863083typwim
709905313539	0640054881ilelht
398743020590	3359216374valscj
909658799824	5591861357usjpmh
327870859249	8861109697nctmhy
891644541071	7353410932eyobaj
284242012079	9406152258ontzdy
827356014688	2387809048aqpxkp
341357647563	8234804722vequiw
213792854742	2712858018foezod
831866853300	8846880323kodmce
706015395842	2401343373vrowto
771397699693	0741945650pkeedq
181975498102	6119783269nmfold
74403052323	8147992410gkndrs
520484572504	6133229965zffgkh
864319055778	8396692221lkycvs
542765434017	3613511395wwxzwj
926811920358	9049262915bvvvcm
440630000275	4962339104qdzliy
106796877612	8641209992dmahhe
655114191614	6167501631hlgeyq
885831183161	1302670674agcuvj
162844334608	0519935151eugjdk
711875587690	8069020236ersrpq
215290900210	5841199121bqrtad
367823883118	4493413091dzzwdt
972935202161	3808432260vsshyb
919018688186	7237341908padwnx
245521580923	1638546533pcytzt
790349530906	7427646263frbubc
169986888059	8527839325kndnbx
174034333510	8141796034itpkxx
242987258224	2768977097ipmxvv
896476066901	6420164783dpmqry
348431273747	8566629273hmxhvz
404155110275	5731642818dvnwkl
940465026141	9803812394yhifzp
701973679986	5622115898uegnqy
625550046533	3543254208mxoqjn
124029518183	8766969874gxxnrp
343455011781	5829666228npahzh
131331128588	0908272503dvtbgn
757806640822	4867810866qelein
370163207306	3634733934mjzrbg
133982615930	6110845481ohtuts
586590007588	2526517743wtxbhy
124611301056	4976731522bpfjnm
939540852075	4737259275fagopa
577183872997	0443996783zybctn
810529517553	6951407601vywfau
31614917085	6552923816zumfql
372984215091	0549300847noidoa
50935258662	2745815124skwjot
665271732320	1332324469fpukej
398508972717	7872244004sozelk
247491963926	2145704818odozja
938295692024	8820221473szorfx
421972594662	7298760817hvbkkg
466220673016	3828320998nzfmyu
566291743909	7671853992kyygqz
702076334845	5238909284xcjcdo
856939111874	1252459753idxmox
658130716774	9829330378dftxno
708116024769	3202821154ymuzfq
991434927056	9162751037cehddo
264183937513	0684706174hshlvx
918850167327	0270059630auqgqh
514123985878	0147374336hpkpnr
833321069641	0799497788efispi
493344411423	9098496662gcplgy
491223410475	6692469464zptbjy
729147815677	0952802512mfegkj
848314642376	6450378993ltzbzj
665939567382	6785507876dytomu
422972110819	2723120818fjgiel
855382782821	3863428629kidsus
310771477107	9958501438anheve
24299684311	8408263039oujvez
722641505880	0755204100eaqvmu
235176531055	3586869985ztxsrc
230251297309	8817757518dmdvdh
856879060417	2667197442btedfg
466879496372	3664731378ninqxr
85848437520	0016401408wiuror
145810273412	9394678791rokvuw
684395208302	2506425008jlajnr
845323419946	0813060521ytwmqy
316169727019	5927033192twtfkg
899293837273	2355509750aiwhiv
347988875692	9687364268oqfbwo
541794237722	8488666622twbwoq
563192243577	2525978118usvarv
513953767143	9280917236tscxld
783951825379	0982456628aubrwu
248330950980	7837856057dnajvw
251176053002	3197701368mofitq
818916563321	0244970691enlwjl
104652962105	0722762067mdjysd
537259753836	8139003682eaxfyr
133233020353	3156685728xuexgn
399583802029	2071139139iixqms
385792511123	4517096531jdicfw
478712518297	4926802377ajjasz
343333834345	8689767034wotynr
970312540833	5211649403wiglrq
90978019034	7001955867sspvcw
797843958812	5871843885odwupu
970447962812	0578647299rdncrj
313117679957	6430414441wdgvnu
600232347547	8275522478pctiks
630018021767	8337557752mlxknl
461278986331	4794980550vxhnyg
748124513430	1324789760mtwpat
642113948110	2288020650eqcoki
920421015313	6756317098kxwvmd
295846757930	2591795983ilietn
843749057076	8190941103aptdjk
620017149865	8471856891pcfwag
881638162430	3256412885ixoifw
78251800659	8809542352mowmog
7517108588	3332737148jfsnee
207921772999	8278976509ohfzjn
42334705665	5400982371kjimdw
400569441999	3433815028zwwrmc
863840611764	7924013912ozqcnc
709971905203	0731584448ajcoyi
246423547831	6042222832lbczpo
395705930861	6582065287bouuzk
833157994886	4142825103pweleu
988325858852	7969549312dchyjm
999643202382	9731336635bznobd
642469436045	7612343924lgdcxu
710981170695	6697857575abdjir
724174518559	2948163389izodpc
366436653358	9287772495ldpnqx
548391035835	7365577755aoueut
292403716483	8647083470pydffj
580452551897	0006932571sqnaqa
140560588056	0529152778eanmfo
771822757812	2280304147lxcsni
869451373225	9171809685majwqo
271551190981	8506599631nrhskm
734095776864	6518417943uypeij
266785702706	7972665678siksmf
701870281052	1321224450winzzu
345674565389	8638038068scntah
748485350976	4836967179pmbthu
569239797065	1972867476jxhaqi
853742400437	4378153193vnxrvw
932401608225	7543170735bvsckj
969049800981	3914151123jmmtri
993215436396	9281554464ohhmav
576448477601	6392380959tkccjx
335501243015	3772159873emgtla
624504249609	8722491706xlfdue
402716561802	4297136832laqalw
263590314709	3646975152akgeqh
674580314602	9217094781adrbzc
560306362853	2699756217vvgohc
94689789663	6398122360vbnrxu
240835296611	0109647149pwiwnu
310976388514	3298730652lcrmqy
98565461268	5229313571iebnfk
157893350626	5819392029oxbhlc
390476566225	8004329014norgsq
334642567221	0143295552gmlqqj
873581500342	1758756284itbkub
646701647196	1276631811jioqsk
501425353971	1590026385rzikqt
230083194186	2700557299kgusng
895261499652	8289523543oqyzsq
538476151760	8707461708ytymvr
248636462147	9283186516uonsfz
593807564373	4882424736qflcim
985016232642	3573925696pyfitl
749881299383	8585182817xgxifn
379611740958	6904252512yqqynw
803415158774	0041496942xljjjg
899938368953	1886795207rxllpt
450875033771	6669512050kwuqbn
513784478960	5525737384zlgxgl
389977804907	9064035535ndxrrp
946683106255	0304838653jmdgtm
978522973153	7550628011eagsgo
230275339857	1873092760cjeppq
161376655877	6523759140bfdvwn
881308692856	3060202810afnodi
214592769917	7918355862rhrixf
688383411152	2289430824lferqb
175870743659	4464254063rkywwp
526017445041	4102882918xubrjd
850671125536	0717505946gvfeqt
383107648846	5585126503htlwwz
30098574862	4477070142tkkbqs
208268585411	6145220880oyitwo
91525987565	7212229639rqwxgy
483086799517	3960792337cwakig
487882694416	6812429263gwqsiw
920071180067	2085864653ftyclb
83658461192	8562292180rkgepx
470104711001	4869565998ffjpnt
717261796562	0312402098efxmne
383078614782	6763966514swpzve
90767238096	1769655314itnbev
106014000232	0534624099lmnpmz
369330534261	0751819966zngdsl
303324288696	4317214029cokdbs
552452579289	8966142518vlyvkv
842293386332	3302123058oxozov
60448491706	7871939886mfqdgf
399450728078	4073686595fuveqm
557256395402	6990710364bpkjpf
478204174204	0986648976ydwxrg
434841625959	1777117884lpiekk
959323858288	0901509616kuwplx
807015188638	8652238099jvmden
845219995540	0770800251udurap
865609309771	3771458433xaxffo
164310188380	9769326988ibdjch
405919179679	5472418032fgeqom
540134541066	8357204961whgccs
347366635183	4130515996peapkm
171911829972	7686038075vvrwtz
984604090840	6304967156tyziue
307173032517	9387322496zxzcco
107302617230	2008226116ipqsmu
677452557782	7877583039zndttq
133299417541	5955899287gzcvkw
831213613493	2837731605qskefp
75526734143	9264422958feuedi
801784685370	5210975698gtsqjp
445801155986	0187234679gdwyon
81946418498	1090066888cfxthh
46239216563	7046215006zcgwkq
119393631681	4092606769tbeadk
87734244525	6928471322xrbvfn
632284086494	3608258268aiajxj
938714120379	9410164759imabva
426149648409	3611111663kztspn
396748403544	7662455754jhuyvz
139966889123	4484162357hxifvg
644590694063	5383402778ywlvow
451942038420	2964779940qykdpa
351274097626	9256502944oyxccm
799391148148	7199322997cfpspx
611753380596	2575351059cbnyie
\.


--
-- TOC entry 3869 (class 0 OID 24713)
-- Dependencies: 217
-- Data for Name: users_info; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.users_info (user_id, account_number, location_id, password) FROM stdin;
1	298537795750	3152	majoor
2	544028694207	3145	majoor
3	148456509144	3160	majoor
4	867476259	3106	majoor
5	233313250426	3143	majoor
6	883007249600	3104	majoor
7	498375389985	3128	majoor
8	488790545998	3136	majoor
9	150860783048	3143	majoor
10	400874478344	3146	majoor
11	505389934545	3158	majoor
12	267908092820	3157	majoor
13	457324950031	3111	majoor
14	57934205593	3132	majoor
15	79193647990	3105	majoor
16	922549739503	3146	majoor
17	7279396949	3138	majoor
18	59403621618	3125	majoor
19	286872016277	3113	majoor
20	602207375039	3126	majoor
21	745530669069	3134	majoor
22	281926212676	3112	majoor
23	536261097680	3130	majoor
24	988311223619	3155	majoor
25	437664978879	3111	majoor
26	422675107573	3140	majoor
27	194929388861	3119	majoor
28	190089261235	3122	majoor
29	69043981780	3117	majoor
30	193773072455	3142	majoor
31	45623858856	3117	majoor
32	439636251061	3128	majoor
33	336694836748	3131	majoor
34	60123553127	3145	majoor
35	515207506316	3128	majoor
36	765505520522	3124	majoor
37	203086398419	3138	majoor
38	99628626956	3154	majoor
39	112579839396	3135	majoor
40	953793373891	3107	majoor
41	689751141287	3157	majoor
42	492640285296	3133	majoor
43	173201091568	3106	majoor
44	377837514449	3129	majoor
45	639707715022	3142	majoor
46	831174199569	3130	majoor
47	202782406327	3144	majoor
48	786203278848	3115	majoor
49	327456736580	3125	majoor
50	600965665889	3105	majoor
51	92162256478	3156	majoor
52	944476330220	3143	majoor
53	399476342513	3154	majoor
54	467579895000	3106	majoor
55	709905313539	3119	majoor
56	398743020590	3101	majoor
57	909658799824	3156	majoor
58	327870859249	3116	majoor
59	891644541071	3151	majoor
60	284242012079	3154	majoor
301	8543914	3161	jjjj
542	3983320	3162	jjjj
783	6076996	3163	1
1024	6680981	3164	12
1265	9931504	3165	12
\.


--
-- TOC entry 3874 (class 0 OID 24740)
-- Dependencies: 222
-- Data for Name: weekly_labors; Type: TABLE DATA; Schema: laborlist_and_wages_db; Owner: postgres
--

COPY laborlist_and_wages_db.weekly_labors (labor_id, weekly_wage, hours_worked) FROM stdin;
108	25	86
67	71	22
79	70	92
69	77	55
84	58	75
93	74	32
113	94	39
85	65	44
110	25	55
72	29	38
73	91	91
116	76	26
114	85	28
63	31	62
68	90	54
\.


--
-- TOC entry 3892 (class 0 OID 25157)
-- Dependencies: 240
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- TOC entry 3894 (class 0 OID 25165)
-- Dependencies: 242
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- TOC entry 3890 (class 0 OID 25151)
-- Dependencies: 238
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add labor model	7	add_labormodel
26	Can change labor model	7	change_labormodel
27	Can delete labor model	7	delete_labormodel
28	Can view labor model	7	view_labormodel
\.


--
-- TOC entry 3896 (class 0 OID 25171)
-- Dependencies: 244
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
\.


--
-- TOC entry 3898 (class 0 OID 25179)
-- Dependencies: 246
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- TOC entry 3900 (class 0 OID 25185)
-- Dependencies: 248
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- TOC entry 3902 (class 0 OID 25243)
-- Dependencies: 250
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- TOC entry 3888 (class 0 OID 25143)
-- Dependencies: 236
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	laborlist_and_wages	labormodel
\.


--
-- TOC entry 3886 (class 0 OID 25135)
-- Dependencies: 234
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2022-11-20 23:20:26.022503+05:30
2	auth	0001_initial	2022-11-20 23:20:26.064608+05:30
3	admin	0001_initial	2022-11-20 23:20:26.073512+05:30
4	admin	0002_logentry_remove_auto_add	2022-11-20 23:20:26.076672+05:30
5	admin	0003_logentry_add_action_flag_choices	2022-11-20 23:20:26.07941+05:30
6	contenttypes	0002_remove_content_type_name	2022-11-20 23:20:26.086384+05:30
7	auth	0002_alter_permission_name_max_length	2022-11-20 23:20:26.089213+05:30
8	auth	0003_alter_user_email_max_length	2022-11-20 23:20:26.092311+05:30
9	auth	0004_alter_user_username_opts	2022-11-20 23:20:26.095139+05:30
10	auth	0005_alter_user_last_login_null	2022-11-20 23:20:26.097833+05:30
11	auth	0006_require_contenttypes_0002	2022-11-20 23:20:26.098535+05:30
12	auth	0007_alter_validators_add_error_messages	2022-11-20 23:20:26.101074+05:30
13	auth	0008_alter_user_username_max_length	2022-11-20 23:20:26.106505+05:30
14	auth	0009_alter_user_last_name_max_length	2022-11-20 23:20:26.109533+05:30
15	auth	0010_alter_group_name_max_length	2022-11-20 23:20:26.113209+05:30
16	auth	0011_update_proxy_permissions	2022-11-20 23:20:26.115729+05:30
17	auth	0012_alter_user_first_name_max_length	2022-11-20 23:20:26.118185+05:30
18	sessions	0001_initial	2022-11-20 23:20:26.124331+05:30
\.


--
-- TOC entry 3903 (class 0 OID 25271)
-- Dependencies: 251
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- TOC entry 3909 (class 0 OID 0)
-- Dependencies: 239
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- TOC entry 3910 (class 0 OID 0)
-- Dependencies: 241
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- TOC entry 3911 (class 0 OID 0)
-- Dependencies: 237
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 28, true);


--
-- TOC entry 3912 (class 0 OID 0)
-- Dependencies: 245
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- TOC entry 3913 (class 0 OID 0)
-- Dependencies: 243
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, false);


--
-- TOC entry 3914 (class 0 OID 0)
-- Dependencies: 247
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- TOC entry 3915 (class 0 OID 0)
-- Dependencies: 249
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- TOC entry 3916 (class 0 OID 0)
-- Dependencies: 235
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 7, true);


--
-- TOC entry 3917 (class 0 OID 0)
-- Dependencies: 233
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 18, true);


--
-- TOC entry 3609 (class 2606 OID 25037)
-- Name: approves approve_unique; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.approves
    ADD CONSTRAINT approve_unique UNIQUE (user_id, supervisor_id, labor_id, leave_id);


--
-- TOC entry 3611 (class 2606 OID 25035)
-- Name: approves approves_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.approves
    ADD CONSTRAINT approves_pkey PRIMARY KEY (leave_id);


--
-- TOC entry 3595 (class 2606 OID 24734)
-- Name: bank_info bank_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.bank_info
    ADD CONSTRAINT bank_info_pkey PRIMARY KEY (account_number);


--
-- TOC entry 3605 (class 2606 OID 24763)
-- Name: business_account business_account_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.business_account
    ADD CONSTRAINT business_account_pkey PRIMARY KEY (email, account_number);


--
-- TOC entry 3583 (class 2606 OID 24844)
-- Name: business_info business_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.business_info
    ADD CONSTRAINT business_info_pkey PRIMARY KEY (business_id, email);


--
-- TOC entry 3579 (class 2606 OID 24870)
-- Name: government_officials government_official_uniquef; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.government_officials
    ADD CONSTRAINT government_official_uniquef UNIQUE (official_id);


--
-- TOC entry 3581 (class 2606 OID 24705)
-- Name: government_officials government_officials_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.government_officials
    ADD CONSTRAINT government_officials_pkey PRIMARY KEY (official_id);


--
-- TOC entry 3597 (class 2606 OID 24739)
-- Name: hourly_labors hourly_labors_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.hourly_labors
    ADD CONSTRAINT hourly_labors_pkey PRIMARY KEY (labor_id);


--
-- TOC entry 3573 (class 2606 OID 24693)
-- Name: labor_supervisor labopr_supervisor_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor_supervisor
    ADD CONSTRAINT labopr_supervisor_pkey PRIMARY KEY (supervisor_id);


--
-- TOC entry 3569 (class 2606 OID 24686)
-- Name: labor labor_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor
    ADD CONSTRAINT labor_pkey PRIMARY KEY (labor_id);


--
-- TOC entry 3571 (class 2606 OID 24916)
-- Name: labor labor_unique; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor
    ADD CONSTRAINT labor_unique UNIQUE (labor_id);


--
-- TOC entry 3601 (class 2606 OID 24837)
-- Name: leave leave_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.leave
    ADD CONSTRAINT leave_pkey PRIMARY KEY (leave_id);


--
-- TOC entry 3577 (class 2606 OID 24700)
-- Name: location_info location_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.location_info
    ADD CONSTRAINT location_info_pkey PRIMARY KEY (location_id);


--
-- TOC entry 3591 (class 2606 OID 24724)
-- Name: payment_info payment_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.payment_info
    ADD CONSTRAINT payment_info_pkey PRIMARY KEY (payment_number);


--
-- TOC entry 3607 (class 2606 OID 25059)
-- Name: pays pays_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.pays
    ADD CONSTRAINT pays_pkey PRIMARY KEY (payment_number);


--
-- TOC entry 3623 (class 2606 OID 24948)
-- Name: personal_info personal_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT personal_info_pkey PRIMARY KEY (email);


--
-- TOC entry 3593 (class 2606 OID 24835)
-- Name: schedule_info schedule_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.schedule_info
    ADD CONSTRAINT schedule_info_pkey PRIMARY KEY (schedule_id);


--
-- TOC entry 3617 (class 2606 OID 24972)
-- Name: schedules schedule_unique; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.schedules
    ADD CONSTRAINT schedule_unique UNIQUE (schedule_id);


--
-- TOC entry 3619 (class 2606 OID 24970)
-- Name: schedules schedules_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (schedule_id);


--
-- TOC entry 3621 (class 2606 OID 24821)
-- Name: supervisor_manager supervisor_manager_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.supervisor_manager
    ADD CONSTRAINT supervisor_manager_pkey PRIMARY KEY (lowerlevel_supervisor_id, manager_id);


--
-- TOC entry 3613 (class 2606 OID 25013)
-- Name: takes_leave takes_leave_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.takes_leave
    ADD CONSTRAINT takes_leave_pkey PRIMARY KEY (leave_id);


--
-- TOC entry 3585 (class 2606 OID 24872)
-- Name: business_info unique_business; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.business_info
    ADD CONSTRAINT unique_business UNIQUE (business_id);


--
-- TOC entry 3587 (class 2606 OID 24848)
-- Name: business_info unique_email; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.business_info
    ADD CONSTRAINT unique_email UNIQUE (email);


--
-- TOC entry 3615 (class 2606 OID 24994)
-- Name: hires unique_hire; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.hires
    ADD CONSTRAINT unique_hire UNIQUE (user_id, business_id, labor_id);


--
-- TOC entry 3625 (class 2606 OID 24940)
-- Name: personal_info unique_labor; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT unique_labor UNIQUE (labor_id);


--
-- TOC entry 3627 (class 2606 OID 24944)
-- Name: personal_info unique_official; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT unique_official UNIQUE (official_id);


--
-- TOC entry 3575 (class 2606 OID 24899)
-- Name: labor_supervisor unique_supervisor; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor_supervisor
    ADD CONSTRAINT unique_supervisor UNIQUE (supervisor_id);


--
-- TOC entry 3629 (class 2606 OID 24942)
-- Name: personal_info unique_supervisor_pinfo; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT unique_supervisor_pinfo UNIQUE (supervisor_id);


--
-- TOC entry 3631 (class 2606 OID 24946)
-- Name: personal_info unique_user; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT unique_user UNIQUE (user_id);


--
-- TOC entry 3603 (class 2606 OID 24756)
-- Name: upi_info upi_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.upi_info
    ADD CONSTRAINT upi_info_pkey PRIMARY KEY (account_number, upi_id);


--
-- TOC entry 3589 (class 2606 OID 24717)
-- Name: users_info users_info_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.users_info
    ADD CONSTRAINT users_info_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3599 (class 2606 OID 24744)
-- Name: weekly_labors weekly_labors_pkey; Type: CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.weekly_labors
    ADD CONSTRAINT weekly_labors_pkey PRIMARY KEY (labor_id);


--
-- TOC entry 3645 (class 2606 OID 25269)
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- TOC entry 3650 (class 2606 OID 25200)
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- TOC entry 3653 (class 2606 OID 25169)
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3647 (class 2606 OID 25161)
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 3640 (class 2606 OID 25191)
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- TOC entry 3642 (class 2606 OID 25155)
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 3661 (class 2606 OID 25183)
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3664 (class 2606 OID 25215)
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- TOC entry 3655 (class 2606 OID 25175)
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- TOC entry 3667 (class 2606 OID 25189)
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3670 (class 2606 OID 25229)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- TOC entry 3658 (class 2606 OID 25264)
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- TOC entry 3673 (class 2606 OID 25250)
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- TOC entry 3635 (class 2606 OID 25149)
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- TOC entry 3637 (class 2606 OID 25147)
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3633 (class 2606 OID 25141)
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3677 (class 2606 OID 25277)
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 3643 (class 1259 OID 25270)
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- TOC entry 3648 (class 1259 OID 25211)
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- TOC entry 3651 (class 1259 OID 25212)
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- TOC entry 3638 (class 1259 OID 25197)
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- TOC entry 3659 (class 1259 OID 25227)
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- TOC entry 3662 (class 1259 OID 25226)
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- TOC entry 3665 (class 1259 OID 25241)
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- TOC entry 3668 (class 1259 OID 25240)
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- TOC entry 3656 (class 1259 OID 25265)
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- TOC entry 3671 (class 1259 OID 25261)
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- TOC entry 3674 (class 1259 OID 25262)
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- TOC entry 3675 (class 1259 OID 25279)
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- TOC entry 3678 (class 1259 OID 25278)
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- TOC entry 3687 (class 2606 OID 25287)
-- Name: users_info account_number_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.users_info
    ADD CONSTRAINT account_number_fkey FOREIGN KEY (account_number) REFERENCES laborlist_and_wages_db.bank_info(account_number) NOT VALID;


--
-- TOC entry 3692 (class 2606 OID 24838)
-- Name: upi_info bank_info_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.upi_info
    ADD CONSTRAINT bank_info_fkey FOREIGN KEY (account_number) REFERENCES laborlist_and_wages_db.bank_info(account_number) NOT VALID;


--
-- TOC entry 3681 (class 2606 OID 24888)
-- Name: labor_supervisor business_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor_supervisor
    ADD CONSTRAINT business_fkey FOREIGN KEY (business_id) REFERENCES laborlist_and_wages_db.business_info(business_id) NOT VALID;


--
-- TOC entry 3705 (class 2606 OID 25000)
-- Name: hires business_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.hires
    ADD CONSTRAINT business_fkey FOREIGN KEY (business_id) REFERENCES laborlist_and_wages_db.business_info(business_id) NOT VALID;


--
-- TOC entry 3693 (class 2606 OID 25088)
-- Name: business_account email_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.business_account
    ADD CONSTRAINT email_fkey FOREIGN KEY (email) REFERENCES laborlist_and_wages_db.business_info(email) NOT VALID;


--
-- TOC entry 3684 (class 2606 OID 24873)
-- Name: business_info governemnt_official_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.business_info
    ADD CONSTRAINT governemnt_official_fkey FOREIGN KEY (official_id) REFERENCES laborlist_and_wages_db.government_officials(official_id) NOT VALID;


--
-- TOC entry 3689 (class 2606 OID 24917)
-- Name: hourly_labors labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.hourly_labors
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3690 (class 2606 OID 24922)
-- Name: weekly_labors labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.weekly_labors
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3713 (class 2606 OID 24949)
-- Name: personal_info labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3707 (class 2606 OID 24973)
-- Name: schedules labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.schedules
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3704 (class 2606 OID 24995)
-- Name: hires labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.hires
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3702 (class 2606 OID 25024)
-- Name: takes_leave labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.takes_leave
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3698 (class 2606 OID 25048)
-- Name: approves labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.approves
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3694 (class 2606 OID 25065)
-- Name: pays labor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.pays
    ADD CONSTRAINT labor_fkey FOREIGN KEY (labor_id) REFERENCES laborlist_and_wages_db.labor(labor_id) NOT VALID;


--
-- TOC entry 3699 (class 2606 OID 25053)
-- Name: approves leave_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.approves
    ADD CONSTRAINT leave_fkey FOREIGN KEY (leave_id) REFERENCES laborlist_and_wages_db.takes_leave(leave_id) NOT VALID;


--
-- TOC entry 3691 (class 2606 OID 25029)
-- Name: leave leave_id_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.leave
    ADD CONSTRAINT leave_id_fkey FOREIGN KEY (leave_id) REFERENCES laborlist_and_wages_db.takes_leave(leave_id) NOT VALID;


--
-- TOC entry 3683 (class 2606 OID 24878)
-- Name: government_officials location_info_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.government_officials
    ADD CONSTRAINT location_info_fkey FOREIGN KEY (location_id) REFERENCES laborlist_and_wages_db.location_info(location_id) NOT VALID;


--
-- TOC entry 3685 (class 2606 OID 24883)
-- Name: business_info location_info_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.business_info
    ADD CONSTRAINT location_info_fkey FOREIGN KEY (location_id) REFERENCES laborlist_and_wages_db.location_info(location_id) NOT VALID;


--
-- TOC entry 3682 (class 2606 OID 24893)
-- Name: labor_supervisor location_info_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor_supervisor
    ADD CONSTRAINT location_info_fkey FOREIGN KEY (location_id) REFERENCES laborlist_and_wages_db.location_info(location_id) NOT VALID;


--
-- TOC entry 3680 (class 2606 OID 24905)
-- Name: labor location_info_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor
    ADD CONSTRAINT location_info_fkey FOREIGN KEY (location_id) REFERENCES laborlist_and_wages_db.location_info(location_id) NOT VALID;


--
-- TOC entry 3686 (class 2606 OID 25282)
-- Name: users_info location_info_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.users_info
    ADD CONSTRAINT location_info_fkey FOREIGN KEY (location_id) REFERENCES laborlist_and_wages_db.location_info(location_id) NOT VALID;


--
-- TOC entry 3712 (class 2606 OID 24932)
-- Name: supervisor_manager manager_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.supervisor_manager
    ADD CONSTRAINT manager_fkey FOREIGN KEY (manager_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3715 (class 2606 OID 24964)
-- Name: personal_info official_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT official_fkey FOREIGN KEY (official_id) REFERENCES laborlist_and_wages_db.government_officials(official_id) NOT VALID;


--
-- TOC entry 3688 (class 2606 OID 25075)
-- Name: payment_info payment_number_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.payment_info
    ADD CONSTRAINT payment_number_fkey FOREIGN KEY (payment_number) REFERENCES laborlist_and_wages_db.pays(payment_number) NOT VALID;


--
-- TOC entry 3709 (class 2606 OID 25080)
-- Name: schedules schedules_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.schedules
    ADD CONSTRAINT schedules_fkey FOREIGN KEY (schedule_id) REFERENCES laborlist_and_wages_db.schedule_info(schedule_id) NOT VALID;


--
-- TOC entry 3679 (class 2606 OID 24900)
-- Name: labor supervisor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.labor
    ADD CONSTRAINT supervisor_fkey FOREIGN KEY (supervisor_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3711 (class 2606 OID 24927)
-- Name: supervisor_manager supervisor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.supervisor_manager
    ADD CONSTRAINT supervisor_fkey FOREIGN KEY (lowerlevel_supervisor_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3714 (class 2606 OID 24954)
-- Name: personal_info supervisor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.personal_info
    ADD CONSTRAINT supervisor_fkey FOREIGN KEY (supervisor_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3708 (class 2606 OID 24978)
-- Name: schedules supervisor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.schedules
    ADD CONSTRAINT supervisor_fkey FOREIGN KEY (supervisor_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3701 (class 2606 OID 25019)
-- Name: takes_leave supervisor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.takes_leave
    ADD CONSTRAINT supervisor_fkey FOREIGN KEY (supervisor_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3697 (class 2606 OID 25043)
-- Name: approves supervisor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.approves
    ADD CONSTRAINT supervisor_fkey FOREIGN KEY (supervisor_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3695 (class 2606 OID 25070)
-- Name: pays supervisor_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.pays
    ADD CONSTRAINT supervisor_fkey FOREIGN KEY (supervisor_id) REFERENCES laborlist_and_wages_db.labor_supervisor(supervisor_id) NOT VALID;


--
-- TOC entry 3706 (class 2606 OID 25292)
-- Name: hires user_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.hires
    ADD CONSTRAINT user_fkey FOREIGN KEY (user_id) REFERENCES laborlist_and_wages_db.users_info(user_id) NOT VALID;


--
-- TOC entry 3696 (class 2606 OID 25297)
-- Name: pays user_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.pays
    ADD CONSTRAINT user_fkey FOREIGN KEY (user_id) REFERENCES laborlist_and_wages_db.users_info(user_id) NOT VALID;


--
-- TOC entry 3710 (class 2606 OID 25302)
-- Name: schedules user_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.schedules
    ADD CONSTRAINT user_fkey FOREIGN KEY (user_id) REFERENCES laborlist_and_wages_db.users_info(user_id) NOT VALID;


--
-- TOC entry 3703 (class 2606 OID 25307)
-- Name: takes_leave user_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.takes_leave
    ADD CONSTRAINT user_fkey FOREIGN KEY (user_id) REFERENCES laborlist_and_wages_db.users_info(user_id) NOT VALID;


--
-- TOC entry 3700 (class 2606 OID 25312)
-- Name: approves user_fkey; Type: FK CONSTRAINT; Schema: laborlist_and_wages_db; Owner: postgres
--

ALTER TABLE ONLY laborlist_and_wages_db.approves
    ADD CONSTRAINT user_fkey FOREIGN KEY (user_id) REFERENCES laborlist_and_wages_db.users_info(user_id) NOT VALID;


--
-- TOC entry 3718 (class 2606 OID 25206)
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3717 (class 2606 OID 25201)
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3716 (class 2606 OID 25192)
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3720 (class 2606 OID 25221)
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3719 (class 2606 OID 25216)
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3722 (class 2606 OID 25235)
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3721 (class 2606 OID 25230)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3723 (class 2606 OID 25251)
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3724 (class 2606 OID 25256)
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


-- Completed on 2022-11-23 21:56:35 IST

--
-- PostgreSQL database dump complete
--

