<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="com.huawei.kdd.omCoverageEvaluation.yang.dao.YangDao">

	<!-- 获取yang覆盖数 -->
	<select id="getYangCoverage" resultType="Integer">

        <!-- 改产品下 所属的领域下的的基线总数 -->
		<if test="start == 2">
			SELECT count(*)
			FROM (select 'x'
			from (select d.guid from
			(select * from t_test_yang_match t where
			<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				t.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and t.version=#{yvo.version}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and t.xpath like '%${yvo.xpath}%'
			</if>
			and t.product=#{yvo.product}
			) b,
			(select * from t_ens_yang_base c where
			<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				c.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and c.version=#{yvo.version}
			</if>
			<if test="yvo.subsys != null and yvo.subsys != '' and yvo.subsys != 'ALL'">
				and c.subsys=#{yvo.subsys}
			</if>
			<if
				test="yvo.feature != null and yvo.feature != '' and yvo.feature != 'ALL'">
				and c.feature=#{yvo.feature}
			</if>
			<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
				and c.source=#{yvo.source}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and c.xpath like '%${yvo.xpath}%'
			</if>
			) d where b.yang_guid=d.guid group by d.guid))
		</if>

		<!-- 该产品下的基线被匹配到的总数 -->
		<if test="start == 3">
			SELECT count(*)
			FROM (select 'x'
			from t_ens_yang_base r,
			(select d.subsys from
			(select * from t_test_yang_match t where
			<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				t.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and t.version=#{yvo.version}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and t.xpath like '%${yvo.xpath}%'
			</if>
			and t.product=#{yvo.product}
			) b,
			(select * from t_ens_yang_base c where
			<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				c.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and c.version=#{yvo.version}
			</if>
			<if test="yvo.subsys != null and yvo.subsys != '' and yvo.subsys != 'ALL'">
				and c.subsys=#{yvo.subsys}
			</if>
			<if
				test="yvo.feature != null and yvo.feature != '' and yvo.feature != 'ALL'">
				and c.feature=#{yvo.feature}
			</if>
			<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
				and c.source=#{yvo.source}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and c.xpath like '%${yvo.xpath}%'
			</if>
			) d where b.yang_guid=d.guid group by d.subsys) s where 
			<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				r.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and r.version=#{yvo.version}
			</if>
			<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
				and r.source=#{yvo.source}
			</if>
			<if
				test="yvo.feature != null and yvo.feature != '' and yvo.feature != 'ALL'">
				and r.feature=#{yvo.feature}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and r.xpath like '%${yvo.xpath}%'
			</if>
			and r.subsys = s.subsys  group by r.xpath
			)
		</if>
			

		<if test="start == 0">
		
			SELECT count(*)
			FROM (select 'x'
			from t_ens_yang_base a 
			<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				 a.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and a.version=#{yvo.version}
			</if>
			<if test="yvo.subsys != null and yvo.subsys != '' and yvo.subsys != 'ALL'">
				and a.subsys=#{yvo.subsys}
			</if>
			<if
				test="yvo.feature != null and yvo.feature != '' and yvo.feature != 'ALL'">
				and a.feature=#{yvo.feature}
			</if>
			<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
				and a.source=#{yvo.source}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and a.xpath like '%${yvo.xpath}%'
			</if>
			group by a.guid)
		</if>


		<!-- api文档中被匹配到的yang文件总数 -->
		<if test="start == 1">
		select sum(t.mguid) counts from
				(select count(c.guid) mguid from
				(select * from yang_base a where   
				<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				a.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and a.version=#{yvo.version}
			</if>
			<if test="yvo.subsys != null and yvo.subsys != '' and yvo.subsys != 'ALL'">
				and a.subsys=#{yvo.subsys}
			</if>
			<if test="yvo.feature != null and yvo.feature != '' and yvo.feature != 'ALL'">
				and a.feature=#{yvo.feature}
			</if>
			<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
				and a.source=#{yvo.source}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and a.xpath like '%${yvo.xpath}%'
			</if>
				) b LEFT JOIN yang_match c on (b.guid=c.yang_guid
				<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				and c.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and c.version=#{yvo.version}
			</if>
				) GROUP BY b.guid) t
		</if>
	</select>


	<!-- yang 柱形图 列表 -->
	<select id="getYangList"
		resultType="com.huawei.kdd.omCoverageEvaluation.yang.povo.YangPo">
		
		<if test="start == 0">
		select t.subsys,count(t.guid) yangTotal,sum(t.mguid) yangCoverage from
				(select a.subsys,a.guid,count(c.guid) mguid from yang_base a left join yang_match c on(a.guid=c.yang_guid) 
				where
		<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
			a.pdu=#{yvo.pdu}
		</if>
		<if test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
			and a.version=#{yvo.version}
		</if>
		<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
			and a.source=#{yvo.source}
		</if>
		<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
			and a.xpath like '%${yvo.xpath}%'
		</if>
		<if test="yvo.subsys != null and yvo.subsys != '' and yvo.subsys != 'ALL'">
			and a.subsys=#{yvo.subsys}
		</if>
		<if test="yvo.feature != null and yvo.feature != '' and yvo.feature != 'ALL'">
			and a.feature=#{yvo.feature}
		</if>
				group by a.subsys,a.guid)t GROUP BY t.subsys
		</if>
		
		
		<if test="start == 1">
		select count(k.aguid) yangTotal,
		count(k.mguid) yangCoverage,
		k.subsys
		from (select m.subsys, max(m.guid) aguid, max(n.guid) mguid
		from (select b.yang_guid, d.xpath,d.subsys,d.feature,d.source,d.guid from
			(select * from t_test_yang_match t where
			<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				t.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and t.version=#{yvo.version}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and t.xpath like '%${yvo.xpath}%'
			</if>
			and t.product=#{yvo.product}
			) b,(select * from t_ens_yang_base c where
			<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				c.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and c.version=#{yvo.version}
			</if>
			<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
				and c.source=#{yvo.source}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and c.xpath like '%${yvo.xpath}%'
			</if>
			) d
			where b.yang_guid=d.guid group by b.yang_guid, d.xpath,d.subsys,d.feature,d.source,d.guid) m LEFT JOIN t_test_yang_match n 
			ON (m.yang_guid = n.guid)
		where 1=1
		<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
			and n.pdu=#{yvo.pdu}
		</if>
		<if
			test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
			and n.version=#{yvo.version}
		</if>
		<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
			and m.source=#{yvo.source}
		</if>
		<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
			and n.xpath like '%${yvo.xpath}%'
		</if>
		group by m.subsys,
		m.guid,
		n.guid) k
		group by k.subsys
		</if>
		
	</select>




	<!-- yang table 表格数据 -->
	<select id="getyangTableList"
		resultType="com.huawei.kdd.omCoverageEvaluation.yang.povo.YangPo">
		
		<if test="start == 1">
		select *
		from (select rownum r,
		g.subsys,
		g.feature,
		g.yangTotal,
		g.yangCoverage
		from (
		select count(aguid) yangTotal,
		count(mguid) yangCoverage,
		k.subsys,
		k.feature
		from (select y.subsys2 subsys,
		y.feature2 feature,
		max(y.guid2) aguid,
		max(n.guid) mguid
		from 
		(select x.yang_guid yangguid,x.xpath xpath2,x.guid guid2,x.feature feature2,x.subsys subsys2,x.source source2 from
		(select d.subsys,d.feature,b.yang_guid from
			(select * from t_test_yang_match t where
			<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				t.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and t.version=#{yvo.version}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and t.xpath like '%${yvo.xpath}%'
			</if>
			and t.product=#{yvo.product}
			) b left join (select * from t_ens_yang_base c where
			<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				c.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and c.version=#{yvo.version}
			</if>
			<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
				and c.source=#{yvo.source}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and c.xpath like '%${yvo.xpath}%'
			</if>
			) d
			on(b.yang_guid=d.guid) group by d.subsys,d.feature,b.yang_guid) m ,t_ens_yang_base x where m.subsys=x.subsys and m.feature = x.feature) y
			
			 LEFT JOIN t_test_yang_match n 
			ON (y.yangguid = n.yang_guid)
		where 1=1
		<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
			and n.pdu=#{yvo.pdu}
		</if>
		<if
			test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
			and n.version=#{yvo.version}
		</if>
		<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
			and y.source2=#{yvo.source}
		</if>
		<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
			and n.xpath like '%${yvo.xpath}%'
		</if>
		group by y.subsys2,
		y.feature2,
		y.guid2,
		n.guid) k
		group by
		k.subsys,k.feature) g
		     <![CDATA[
				where rownum <= #{yvo.endRow})
				where r > #{yvo.startRow}
			]]>
		</if>
		
		
		<if test="start == 0">
			select *
		from (select rownum r, t.subsys,t.feature,count(t.guid) yangTotal,sum(t.mguid) yangCoverage from
				(select a.subsys,a.feature,a.guid,count(c.guid) mguid from yang_base a left join yang_match c on(a.guid=c.yang_guid) 
				where 
				<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
			 a.pdu=#{yvo.pdu}
		</if>
		<if
			test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
			and a.version=#{yvo.version}
		</if>
		<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
			and a.source=#{yvo.source}
		</if>
		<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
			and a.xpath like '%${yvo.xpath}%'
		</if>
		<if test="yvo.subsys != null and yvo.subsys != '' and yvo.subsys != 'ALL'">
			and a.subsys=#{yvo.subsys}
		</if>
		<if
			test="yvo.feature != null and yvo.feature != '' and yvo.feature != 'ALL'">
			and a.feature=#{yvo.feature}
		</if>
				group by a.subsys,a.feature,a.guid)t GROUP BY t.subsys,t.feature
		 <![CDATA[
				where rownum <= #{yvo.endRow})
				where r > #{yvo.startRow}
			]]>
		</if>
	</select>



	<!-- yang table 表格总数 -->
	<select id="getYangTotal" resultType="Integer">

		<if test="start == 1">
			select count(t.counts)
			from (select count(*) counts from
			(
			select d.subsys,d.feature from
			(select * from t_test_yang_match t where
			<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				t.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and t.version=#{yvo.version}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and t.xpath like '%${yvo.xpath}%'
			</if>
			and t.product=#{yvo.product}
			) b,
			(select * from t_ens_yang_base c where
			<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				c.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and c.version=#{yvo.version}
			</if>
			<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
				and c.source=#{yvo.source}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and c.xpath like '%${yvo.xpath}%'
			</if>
			) d
			where b.yang_guid=d.guid group by d.subsys,d.feature) c group by
			c.subsys,c.feature) t
		</if>


		<if test="start == 0">
		select count(*)
			from (
		select t.subsys,t.feature,count(t.guid) aguid,sum(t.mguid) mguid from
				(select a.subsys,a.feature,a.guid,count(c.guid) mguid from yang_base a left join yang_match c on(a.guid=c.yang_guid) 
				where
				<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				 a.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and a.version=#{yvo.version}
			</if>
			<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
				and a.source=#{yvo.source}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and a.xpath like '%${yvo.xpath}%'
			</if>
				group by a.subsys,a.feature,a.guid)t GROUP BY t.subsys,t.feature)y
		</if>

	</select>



	<!-- yang xpath 列表 -->
	<select id="getyangXpathList"
		resultType="com.huawei.kdd.omCoverageEvaluation.yang.povo.YangPo">
		
		select *
		from (select rownum r, max(t.subsys) subsys,max(t.feature) feature,t.xpath,sum(t.mguid) yangCover2 from
				(select a.guid,a.subsys,a.feature,a.xpath,count(c.guid) mguid from yang_base a LEFT JOIN yang_match c on(a.guid=c.yang_guid) 
				where
				<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
			a.pdu=#{yvo.pdu}
		</if>
		<if test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
			and a.version=#{yvo.version}
		</if>
		<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
			and a.source=#{yvo.source}
		</if>
		<if
			test="yvo.feature != null and yvo.feature != '' and yvo.feature != 'ALL'">
			and a.feature=#{yvo.feature}
		</if>
		<if test="yvo.subsys != null and yvo.subsys != '' and yvo.subsys != 'ALL'">
			and a.subsys=#{yvo.subsys}
		</if>
		<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
			and a.xpath like '%${yvo.xpath}%'
		</if>
				GROUP BY a.guid,a.subsys,a.feature,a.xpath) t GROUP BY t.xpath order by
		yangCover2 desc
		<![CDATA[
				where rownum <= #{yvo.endRow})
				where r > #{yvo.startRow}
			]]>
	</select>



	<!-- yang table 表格总数 -->
	<select id="getyangXpathTotal" resultType="Integer">

        <if test="start == 1">
			select count(t.counts)
			from (select count(*) counts from
			(
			select d.guid from
			(select * from t_test_yang_match t where
			<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				t.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and t.version=#{yvo.version}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and t.xpath like '%${yvo.xpath}%'
			</if>
			and t.product=#{yvo.product}
			) b,
			(select * from t_ens_yang_base c where
			<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
				c.pdu=#{yvo.pdu}
			</if>
			<if
				test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
				and c.version=#{yvo.version}
			</if>
			<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
				and c.source=#{yvo.source}
			</if>
			<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
				and c.xpath like '%${yvo.xpath}%'
			</if>
			<if
			test="yvo.feature != null and yvo.feature != '' and yvo.feature != 'ALL'">
			and c.feature=#{yvo.feature}
		</if>
		<if test="yvo.subsys != null and yvo.subsys != '' and yvo.subsys != 'ALL'">
			and c.subsys=#{yvo.subsys}
		</if>
			) d
			where b.yang_guid=d.guid group by d.guid) c group by
			c.guid) t
       </if>
       
       
       <if test="start == 0">
			 select count(*)from(
				select max(t.subsys) subsys,max(t.feature) feature,t.xpath,sum(t.mguid) yangcover from
				(select a.guid,a.subsys,a.feature,a.xpath,count(c.guid) mguid from yang_base a LEFT JOIN yang_match c on(a.guid=c.yang_guid) 
				where
				<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
			a.pdu=#{yvo.pdu}
		</if>
		<if
			test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
			and a.version=#{yvo.version}
		</if>
		<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
			and a.source=#{yvo.source}
		</if>
		<if
			test="yvo.feature != null and yvo.feature != '' and yvo.feature != 'ALL'">
			and a.feature=#{yvo.feature}
		</if>
		<if test="yvo.subsys != null and yvo.subsys != '' and yvo.subsys != 'ALL'">
			and a.subsys=#{yvo.subsys}
		</if>
		<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
			and a.xpath like '%${yvo.xpath}%'
		</if>
				GROUP BY a.guid,a.subsys,a.feature,a.xpath) t GROUP BY t.xpath)y
		</if>
	</select>


	<!--获得yang下匹配数据详细数据列表 -->
	<select id="getyangDetail" resultType="com.huawei.kdd.omCoverageEvaluation.yang.povo.YangPo">
	
	select c.value,c.operation,c.type from
				(select * from yang_base a where
				<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
			 a.pdu=#{yvo.pdu}
		</if>
		<if
			test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
			and a.version=#{yvo.version}
		</if>
		<if
			test="yvo.subsys != null and yvo.subsys != '' and yvo.subsys != 'ALL'">
			and a.subsys=#{yvo.subsys}
		</if>
		<if test="yvo.feature != null and yvo.feature != '' and yvo.feature != 'ALL'">
			and a.feature=#{yvo.feature}
		</if>
		<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
			and a.xpath=#{yvo.xpath}
		</if>
				)b
				left join yang_match c on (b.guid=c.yang_guid) GROUP BY c.value,c.operation,c.type
	</select>



	<select id="getversionList" resultType="com.huawei.kdd.info.povo.InfoPo">
		select
		distinct(version) as name
		from
		t_ens_yang_base b
		where
		1=1
		<if test="pdu != null and pdu != 'NULL' and pdu != '' and pdu != 'ALL'">
			and b.pdu = #{pdu}
		</if>
		order by
		version desc
	</select>


	<select id="getsourceList" resultType="com.huawei.kdd.info.povo.InfoPo">
		select
		distinct(source) as name
		from
		t_ens_yang_base b
		where
		1=1
		order by
		source desc
	</select>


	<select id="getproductList" resultType="com.huawei.kdd.info.povo.InfoPo">
		select
		distinct(product) as name
		from
		(select m.* from
		t_ens_yang_base b, t_test_yang_match m
		where 1=1 and
		b.pdu =m.pdu
		and b.version =m.version
		and b.xpath =m.xpath
		) c
		where 1=1
		<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
			and c.pdu=#{yvo.pdu}
		</if>
		<if
			test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
			and c.version=#{yvo.version}
		</if>
		<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
			and c.source=#{yvo.source}
		</if>
		<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
			and c.xpath like '%${yvo.source}%'
		</if>
		order by
		c.product desc
	</select>


	<select id="getsubsysList" resultType="com.huawei.kdd.info.povo.InfoPo">
		select
		distinct(subsys) as name
		from
		t_ens_yang_base b
		where
		1=1
		<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
			and b.pdu=#{yvo.pdu}
		</if>
		<if
			test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
			and b.version=#{yvo.version}
		</if>
		<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
			and b.source=#{yvo.source}
		</if>
		<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
			and b.xpath like '%${yvo.source}%'
		</if>
		order by
		subsys desc
	</select>


	<select id="getfeatureList" resultType="com.huawei.kdd.info.povo.InfoPo">
		select
		distinct(feature) as name
		from
		t_ens_yang_base b
		where
		1=1
		<if test="yvo.pdu != null and yvo.pdu != '' and yvo.pdu != 'ALL'">
			and b.pdu=#{yvo.pdu}
		</if>
		<if
			test="yvo.version != null and yvo.version != '' and yvo.version != 'ALL'">
			and b.version=#{yvo.version}
		</if>
		<if test="yvo.subsys != null and yvo.subsys != '' and yvo.subsys != 'ALL'">
			and b.subsys=#{yvo.subsys}
		</if>
		<if test="yvo.source != null and yvo.source != '' and yvo.source != 'ALL'">
			and b.source=#{yvo.source}
		</if>
		<if test="yvo.xpath != null and yvo.xpath != '' and yvo.xpath != 'ALL'">
			and b.xpath like '%${yvo.source}%'
		</if>
		order by
		feature desc
	</select>

</mapper>
