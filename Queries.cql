// Sample cypher queries for performance evaluation:

//Query 1 - find all the users who have visited the checkoutpage on a particular date of interest.
match (u:User)-[r:visits]->(:Page_category {page_type:'checkoutpage'})
where substring(r.time,0,10)='2017-12-03'
return count(distinct u);

//Query2 - find the user-pool for a particular location.
match(l:Location{city:'Seattle'}) return size((l)<--());
match(u:User)-[:is_from]->(:Location{city:'Seattle'}) return count(u);

//Query3- count of all the products that a particular user is interested in.
match(u:User {uid:'user_id'})-[r:interested_in]->(:Product_name)
return count(r);

//Query4 - count of all the users who visit the product page.
match(u:User)-[:visits]->(pag_cat:Page_category)
where pag_cat.page_type='productpage' return count(distinct u);

//Query5 - count of all the users who visited the checkoutpage.
match (u:User)-[:visits]->(pag_cat:Page_category)
where pag_cat.page_type='checkoutpage' return count(distinct u);

//Query6 - count the users who visited the cartpage and the checkoutpage.
match(pag_cat:Page_category{page_type:'cartpage'})<-[:visits]-(u:User)-[:visits]->(pag_cat1:Page_category{page_type:'checkoutpage'})
return count(distinct u);

//Query7- count the users who checked out and also used the search option provided in the site.
match (:Page_category{page_type:'checkoutpage'})<-[:visits]-(u:User)-[:searched]->(:Keywords) return count(distinct u);


// Query to calculate Jaccard similarity - 
match (u1:User)-[:interested_in]->(p1:Product_name {name:'ideapad-100-series'})<-[:interested_in]-(u2:User)
where u1<>u2 
with u1, u2, count(distinct p1.name) as intersection_count
match (u:User)-[:interested_in]->(p:Product_name)
where u in [u1, u2]
with u1, u2, intersection_count, count(distinct p.name) as union_count
with u1, u2, intersection_count, union_count, (intersection_count*1.0/union_count) as jaccard_index
merge (u1)-[r:similar_to]-(u2)
on create set r.similarity = jaccard_index

// Other weight metric - 
match (u:User)-[:interested_in]->(p:Product_name) 
with collect(u) as users
FOREACH (us1 in users |
    FOREACH(us2 in users |
		merge (us1)-[r:similar_to]->(us2)
        on create set r.weight=100
        on match set r.weight = r.weight + 100
     )   
)



