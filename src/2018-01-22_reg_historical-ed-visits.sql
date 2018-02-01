
----------------------------------------------
-- HISTORICAL AGGREGATE ED DATA FOR USE IN FCASTS 
----------------------------------------------

--TODO: -------------------------------------
-- > age group nulls?? 
-- >  
----------------------------------------------


---------------------------------------------------
-- pull 14/15 data: 
-- total 366,856 visits 

--select sum(visits) as total_visits_14_15
--from(
	
	select count(*) as Visits
		, FacilityLongName as Site
		, AgeGroup3MVHHSC
		, GenderDescription
		, LocalHealthAuthority
		--, ChiefComplaintSystem
		, TriageAcuityDescription
	from EDMart.dbo.vwEDVisitIdentifiedRegional e
		left join ADRMart.Dim.Age a 
			on e.Age = a.Age
	where StartDateFiscalYear = '14/15'
	group by FacilityLongName
		, AgeGroup3MVHHSC
		, GenderDescription
		, LocalHealthAuthority
		--, ChiefComplaintSystem
		, TriageAcuityDescription
	order by AgeGroup3MVHHSC
		, GenderDescription
		, [Site] 
	
--) as sub1


---------------------------------------------------
-- pull 15/16 data: 
-- total 429,181 visits 

--select sum(visits) as total_visits_15_16
--from(

	select count(*) as Visits
		, FacilityLongName as Site
		, AgeGroup3MVHHSC
		, GenderDescription
		, LocalHealthAuthority
		--, ChiefComplaintSystem
		, TriageAcuityDescription
	from EDMart.dbo.vwEDVisitIdentifiedRegional e 
		left join ADRMart.Dim.Age a 
			on e.Age = a.Age
	where StartDateFiscalYear = '15/17'
	group by FacilityLongName
		, AgeGroup3MVHHSC
		, GenderDescription
		, LocalHealthAuthority
		--, ChiefComplaintSystem
		, TriageAcuityDescription
	order by AgeGroup3MVHHSC
		, GenderDescription
		, [Site]

--) as sub2

---------------------------------------------------
-- 2015/16 data for Howe Sound sites (not in EDMart in 2014/15)
-- total visits: 41,199

--select sum(visits) as total_visits_15_16
--from(

	select count(*) as Visits
		, FacilityLongName as Site
		, AgeGroup3MVHHSC
		, GenderDescription
		, LocalHealthAuthority
		--, ChiefComplaintSystem
		, TriageAcuityDescription
	from EDMart.dbo.vwEDVisitIdentifiedRegional e 
		left join ADRMart.Dim.Age a 
			on e.Age = a.Age
	where StartDateFiscalYear = '15/16' 
		and FacilityLongName in ('Pemberton D & T Centre'
			, 'Squamish General Hospital'
			, 'Whistler D & T Centre')
	group by FacilityLongName
		, AgeGroup3MVHHSC
		, GenderDescription
		, LocalHealthAuthority
		--, ChiefComplaintSystem
		, TriageAcuityDescription
	order by AgeGroup3MVHHSC
		, GenderDescription
		, [Site]

--) sub3



---------------------------------------------------
-- pull 16/17 data: 
-- total   xx visits 

--select sum(visits) as total_visits_16_17
--from(

	select count(*) as Visits
		, FacilityLongName as Site
		, AgeGroup3MVHHSC
		, GenderDescription
		, LocalHealthAuthority
		, ChiefComplaintSystem
		, TriageAcuityDescription
	from EDMart.dbo.vwEDVisitIdentifiedRegional e 
		left join ADRMart.Dim.Age a 
			on e.Age = a.Age
	where StartDateFiscalYear = '16/17'
	group by FacilityLongName
		, AgeGroup3MVHHSC
		, GenderDescription
		, LocalHealthAuthority
		, ChiefComplaintSystem
		, TriageAcuityDescription
	order by AgeGroup3MVHHSC
		, GenderDescription
		, [Site]

--) as sub2