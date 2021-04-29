use pubs

select * from authors
select * from titleauthor
select * from sales
select * from publishers
select * from titles
--1 question
select city,count(au_id) No_Of_Authors_From_City from authors group by city;

--2 question
select distinct au_fname,au_lname,city from authors where city not in 
(select city from publishers where pub_name='New Moon Books');

--3 question
 create proc proc_ToUpdatePrice(@fname varchar(20),@lname varchar(20),@price money)
 as
 begin 
 update titles set price=@price where title_id in
 (select title_id from titleauthor where au_id in
 (select au_id from authors where au_fname=@fname and au_lname=@lname))
 end

 exec proc_ToUpdatePrice 'Marjorie','Green',20.99

 --4 quesion
create function fu_taxTable(@qty varchar(10))
returns @Table table(title_id varchar(10),tax varchar(10))
as
begin
	declare
	@title_id varchar(10),
	@tax varchar(10),
	@qty1 int
	set @qty1 = (select distinct qty from sales where ord_num=@qty)
		if(@qty1 < 10)
			set @tax = '2%'
		else if(@qty1 >= 10 and @qty1 <= 20)
			set @tax = '5%'
		else if(@qty1 >= 20 and @qty1 <= 30)
			set @tax = '6%'
		else
			set @tax = '7.5%'
		set @title_id = (select title_id from sales where ord_num=@qty)
		insert into @Table values(@title_id,@tax) 

	return
end

select title_id,tax from dbo.fu_taxTable('6871')