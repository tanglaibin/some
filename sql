<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="com.huawei.z00448113.dao.AllContrastDao">

    <!-- 风险管理数量-->
    <select id="riskCount" resultType="com.huawei.z00448113.vo.allcontrastvo.RiskCountPo">
        select t.risk_type riskType, t.risk_level riskLevel, count(t.risk_level) riskCount
        from t_ens_risk t
        where t.pdu = #{pdu}
        and t.version = #{pdtVersion}
        group by t.risk_type,t.risk_level
    </select>

    <!-- 场景覆盖率-->
    <select id="getSceneTrend" resultType="com.huawei.z00448113.vo.allcontrastvo.TrendPo">
        select * from
        (select   t.rate rate
        from t_test_scene_datecover t
        where t.checktime &lt; = to_date(#{selectDate},'yyyy-mm-dd')
        and t.pdu = #{pdu}
        and t.pdt_version = #{pdtVersion}
        and t.source = 'ALL'
        order by t.checktime desc)
        where rownum = 1
    </select>

    <!-- 命令行覆盖率-->
    <select id="getCmdTrend" resultType="com.huawei.z00448113.vo.allcontrastvo.TrendPo">
        select * from
        (select t.testcover, t.usertotal
        from t_test_cmd_datecover t
        where t.checktime &lt; = to_date(#{selectDate}, 'yyyy-mm-dd')
        and t.pdu = #{pdu}
        and t.pdt_version = #{pdtVersion}
        and t.source = 'ALL'
        order by t.checktime desc)
        where rownum = 1
    </select>

    <!-- 日志覆盖趋势图-->
    <select id="getLogTrend" resultType="com.huawei.z00448113.vo.allcontrastvo.TrendPo">
        select * from (
        select  t.testcover,t.usertotal
        from t_test_log_datecover t
        where t.checktime &lt; = to_date(#{selectDate},'yyyy-mm-dd')
        and t.pdu = #{pdu}
        and t.version = #{pdtVersion}
        and t.source = 'ALL'
        order by t.checktime desc
        )
        where rownum = 1
    </select>

    <!-- 告警覆盖趋势图-->
    <select id="getAlarmTrend" resultType="com.huawei.z00448113.vo.allcontrastvo.TrendPo">
        select * from (
        select  t.testcover,t.usertotal
        from t_test_alarm_datecover t
        where t.checktime &lt; = to_date(#{selectDate},'yyyy-mm-dd')
        and t.pdu = #{pdu}
        and t.version = #{pdtVersion}
        and t.source = 'ALL'
        order by t.checktime desc
        )
        where rownum = 1
    </select>

    <!-- 性能覆盖趋势图-->
    <select id="getBusinessTrend" resultType="com.huawei.z00448113.vo.allcontrastvo.TrendPo">
        select * from (
        select  t.testCover,t.userTotal
        from t_test_business_datecover t
        where t.checktime &lt; = to_date(#{selectDate},'yyyy-mm-dd')
        and t.pdu = #{pdu}
        and t.version = #{pdtVersion}
        and t.source = 'ALL'
        order by t.checktime desc
        )
        where rownum = 1
    </select>

    <!-- 获得版本下拉框 -->
    <select id="pdtversionList" resultType="com.huawei.common.entity.vo.InfoPo">
        select distinct info.pdt_version as name
        from t_scenes_test_datainfo info
        where info.PDU = #{pdu}
        order by info.pdt_version desc
    </select>

    <!-- 所有环形图-->
    <select id="getChart" resultType="com.huawei.z00448113.po.AllContrastPo">
        select t.all_cover allContrastCover,
        t.all_total allContrastTotal,
        t.scene_cover subSceneCover,
        t.scene_total subSceneTotal,
        t.cmd_cover cmdCover,
        t.cmd_total cmdTotal,
        t.log_cover logCover,
        t.log_total logTotal,
        t.alarm_cover alarmCover,
        t.alarm_total alarmTotal
        <!--t.business_cover businessCover,
        t.business_total businessTotal-->
        from t_ens_all_ringchart t
        where t.pdu = #{pdu}
        and t.version = #{pdtVersion}
    </select>

    <!-- 性能覆盖饼图数据-->
    <select id="getBusinessCover" resultType="Integer">
        select count(distinct ub.type) from
        t_cube_ens_business ub,
        t_cube_ens_insp sp,
        t_scenes_test_business tb ,
        ebg_custorem_record_info info
        where ub.fk_insp = sp.guid and tb.type =ub.type
        and sp.pdu =info.product and sp.site =info.customer_name and info.delflag =0
        and tb.pdu=#{pdu}
        and tb.version=#{pdtVersion}
    </select>

    <select id="getBusinessTotal" resultType="Integer">
        select count(distinct ub.type)
        from t_cube_ens_business ub,t_cube_ens_insp sp,ebg_custorem_record_info info
        where ub.fk_insp = sp.guid
        and sp.pdu =info.product and sp.site =info.customer_name and info.delflag =0
        and sp.pdu=#{pdu}
    </select>

    <!-- 场景覆盖高风险top5 -->
    <select id="sceneTop5" resultType="com.huawei.z00448113.po.AllContrastPo">
        select rownum r, tt.*
        from (
        select distinct s.subscene name,c.cover/100 coverRate
        from t_ens_scene_cover c,ebg_customer_scene_id s
        where c.scene_id =s.scene_id
        and c.pdu = #{pdu}
        and c.pdt_version = #{pdtVersion}
        order by coverRate
        )tt
        <![CDATA[
		where rownum<=5
	]]>
    </select>

    <!-- 命令行高风险top5 -->
    <select id="cmdTop5" resultType="com.huawei.z00448113.po.AllContrastPo">
        select t.risk_name name ,t.risk_rate coverRate
        from t_test_risk_top5 t
        where t.risk_type = 1
        and t.pdu = #{pdu}
        and t.version = #{pdtVersion}
        order by t.sort
    </select>

    <!-- 日志高风险top5 -->
    <select id="logTop5" resultType="com.huawei.z00448113.po.AllContrastPo">
        select rownum r, tt.*
        from (
        select ue.feature name, te.testTotal/ue.userTotal coverRate
        from (
        select b.feature, count(distinct b.guid) userTotal
        from t_cube_ens_log_match um, t_ens_log_base b
        where um.log_guid =b.guid
        and b.pdu = #{pdu}
        and b.version = #{pdtVersion}
        group by b.feature
        ) ue
        left join (select b.feature, count(distinct b.guid) testTotal
        from t_ac_ens_log_match tm, t_ens_log_base b ,t_cube_ens_log_match um
        where tm.log_guid = b.guid
        and b.guid =um.log_guid
        and b.pdu = #{pdu}
        and b.Version = #{pdtVersion}
        group by b.feature) te on ue.feature = te.feature
        order by coverRate NULLS FIRST
        )tt
        <![CDATA[
		where rownum<=5
	]]>
    </select>

    <!-- 告警高风险top5 -->
    <select id="alarmTop5" resultType="com.huawei.z00448113.po.AllContrastPo">
        select rownum r, tt.*
        from (
        select ue.feature name, te.testTotal/ue.userTotal coverRate
        from (
        select b.feature, count(distinct b.guid) userTotal
        from t_cube_ens_alarm um, t_ens_alarm_base b
        where um.alarm_guid =b.guid
        and b.pdu = #{pdu}
        and b.version = #{pdtVersion}
        group by b.feature
        ) ue
        left join (select b.feature, count(distinct b.guid) testTotal
        from t_ac_ens_alarm_match tm, t_ens_alarm_base b ,t_cube_ens_alarm um
        where tm.alarm_guid = b.guid
        and b.guid =um.alarm_guid
        and b.pdu = #{pdu}
        and b.Version = #{pdtVersion}
        group by b.feature) te on ue.feature = te.feature
        order by coverRate NULLS FIRST
        )tt
        <![CDATA[
		where rownum<=5
	]]>
    </select>
 </mapper>
 
 <?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="com.huawei.z00448113.dao.BusinessContrastDao">

    <!-- 获取来源列表 -->
    <select id="getSourceList" resultType="com.huawei.common.entity.vo.site.InfoPo">
        select distinct source as
        name from t_scenes_test_business
    </select>

    <!-- 覆盖趋势图-->
    <select id="getMaxTrend" resultType="com.huawei.z00448113.vo.allcontrastvo.TrendPo">
        select * from (
        select  t.testCover,t.userTotal
        from t_test_business_datecover t
        where t.checktime &lt; = to_date(#{selectDate},'yyyy-mm-dd')
        and t.pdu = #{pdu}
        and t.version = #{pdtversion}
        and t.source = #{source}
        order by t.checktime desc
        )
        where rownum = 1
    </select>

    <!-- 获得pdu下拉框 -->
    <select id="getPduList" resultType="com.huawei.common.entity.vo.site.InfoPo">
        select distinct PDU as name
        from t_scenes_test_datainfo
        where PDU is not null
        order by name
    </select>

    <!-- 获得下拉框主场景 -->
    <select id="getSceneList" resultType="com.huawei.common.entity.vo.site.InfoPo">
        select distinct SCENE as name from ebg_customer_scene_id
        where 1=1
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and PDU = #{pdu}
        </if>
        order by scene
    </select>

    <!-- 获得版本下拉框 -->
    <select id="pdtversionList" resultType="com.huawei.common.entity.vo.site.InfoPo">
        select distinct info.pdt_version as name
        from t_scenes_test_datainfo info
        where info.PDU = #{pdu}
        order by info.pdt_version
    </select>

    <!-- 获得局点下拉框 -->
    <select id="getSiteList" resultType="com.huawei.common.entity.vo.site.InfoPo">
        select distinct insp.alias as name from T_CUBE_ENS_INSP
        insp,ebg_custorem_record_info info
        where 1=1
        and
        insp.site=info.customer_name
        and insp.pdu=info.product
        <if test="null != city and '' != city and 'ALL' != city">
            and insp.CITY = #{city}
        </if>
        <if test="null != conditionType and '' != conditionType and 'ALL' != conditionType">
            and info.condition_type = #{conditionType}
        </if>
        <if
                test="null != customerType and '' != customerType and 'ALL' != customerType">
            and info.customertype = #{customerType}
        </if>
        <if test="null != area and '' != area and 'ALL' != area">
            and insp.area = #{area}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and insp.PDU = #{pdu}
        </if>
        order by insp.alias
    </select>

    <!-- 获得区域下拉框的值 -->
    <select id="getAreaList" resultType="com.huawei.common.entity.vo.site.InfoPo">
        select distinct AREA as name from T_CUBE_ENS_INSP
        where 1=1
        <if test="null != site and '' != site and 'ALL' != site">
            and alias = #{site}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and PDU = #{pdu}
        </if>
        order by AREA
    </select>

    <!-- 获得城市下拉框的值 -->
    <select id="getCityList" resultType="com.huawei.common.entity.vo.site.InfoPo">
        select distinct CITY as name from T_CUBE_ENS_INSP
        where 1=1
        <if test="null != site and '' != site and 'ALL' != site">
            and alias = #{site}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and PDU = #{pdu}
        </if>
        <if test="null != area and '' != area and 'ALL' != area">
            and AREA = #{area}
        </if>
        order by CITY
    </select>

    <!-- 获得场景类别下拉框的值 -->
    <select id="getConditionTypeList" resultType="com.huawei.common.entity.vo.site.InfoPo">
        select distinct t.CONDITION_TYPE as name from
        EBG_CUSTOREM_RECORD_INFO
        t left
        join ebg_area_list area
        on area.region = t.area where
        t.CUSTOMERTYPE is
        not null and t.CONDITION_TYPE is not null
        <if test="null != area and '' != area and 'ALL' != area">
            and area.country = #{area}
        </if>
        <if test="null != city and '' != city and 'ALL' != city">
            and t.area = #{city}
        </if>
        <if
                test="null != customerType and '' != customerType and 'ALL' != customerType">
            and t.customertype = #{customerType}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and t.PRODUCT = #{pdu}
        </if>
        order by t.CONDITION_TYPE
    </select>

    <!-- 获得局点类别下拉框的值 -->
    <select id="getCustomTypeList" resultType="com.huawei.common.entity.vo.site.InfoPo">
        select distinct ne.custom_type as name from T_CUBE_ENS_INSP
        insp
        inner join
        t_cube_ens_ne ne on (insp.fk_ne = ne.guid)
        where
        ne.custom_type is not null
        <if test="null !=area  and '' != area and 'ALL' != area">
            and insp.area=#{area}
        </if>
        <if test="null != city and '' != city and 'ALL' != city">
            and insp.country=#{city}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and insp.pdu=#{pdu}
        </if>
        <if test="null != site and '' != site and 'ALL' != site">
            and insp.alias=#{site}
        </if>
        order by ne.custom_type
    </select>


    <!-- 获取客户指标的最大值和最小值  -->
    <select id="getCustomerValueScope" resultType="com.huawei.z00448113.vo.businesscontrast.BusinessInforRVO">
        select b.type type,min(to_number(b.value)) customerMinValue,max(to_number(b.value)) customerMaxValue
        from  t_cube_ens_business b,
        t_cube_ens_insp insp,
        ebg_custorem_record_info info
        where b.fk_insp=insp.guid
        and insp.pdu = info.product
        and info.customer_name=insp.site
        and regexp_like(b.value,'^[0-9]+([.]{1}[0-9]+){0,1}$')
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and insp.pdu = #{pdu}
        </if>
        <if test="null != site and '' != site and 'ALL' != site">
            and insp.alias = #{site}
        </if>
        <if test="null != area and '' != area and 'ALL' != area">
            and insp.area = #{area}
        </if>
        <if test="null != city and '' != city and 'ALL' != city">
            and insp.city = #{city}
        </if>
        <if test="null != conditionType and '' != conditionType and 'ALL' != conditionType">
            and info.condition_type = #{conditionType}
        </if>
        <if
                test="null != customerType and '' != customerType and 'ALL' != customerType">
            and info.customertype = #{customerType}
        </if>
        group by b.type
    </select>

    <!-- 获取测试数据指标的最大值和最小值  -->
    <select id="getTestValueScope" resultType="com.huawei.z00448113.vo.businesscontrast.BusinessInforRVO">
        select b.type type, min(to_number(b.value)) testMinValue ,max(to_number(b.value)) testMaxValue
        from  t_scenes_test_business b
        where 1 = 1
        and regexp_like(b.value,'^[0-9]+([.]{1}[0-9]+){0,1}$')
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and b.pdu = #{pdu}
        </if>
        <if test="null != pdtversion and '' != pdtversion and 'ALL' != pdtversion">
            and b.version = #{pdtversion}
        </if>
        <if test="null != source and '' != source and 'ALL' != source">
            and b.source = #{source}
        </if>
        group by b.type
    </select>

    <select id="getBusinessList1" resultType="com.huawei.z00448113.vo.businesscontrast.BusinessInforRVO">
        <!-- select *
        from (select rownum r, tt.*
        from ( -->
        select c.type,
        min(to_number(c.value)) customerMinValue,
        max(to_number(c.value)) customerMaxValue,
        min(to_number(t.value)) testMinValue,
        max(to_number(t.value)) testMaxValue
        from t_cube_ens_business      c,
        t_scenes_test_business   t,
        t_cube_ens_insp          insp,
        ebg_custorem_record_info info
        where c.type = t.type
        and c.fk_insp = insp.guid
        and insp.pdu = info.product
        and info.customer_name = insp.site
        and insp.pdu=t.pdu
        and regexp_like(c.value,'^[0-9]+([.]{1}[0-9]+){0,1}$')
        and regexp_like(t.value,'^[0-9]+([.]{1}[0-9]+){0,1}$')
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and insp.pdu = #{pdu}
        </if>
        <if test="null != site and '' != site and 'ALL' != site">
            and insp.alias = #{site}
        </if>
        <if test="null != area and '' != area and 'ALL' != area">
            and insp.area = #{area}
        </if>
        <if test="null != city and '' != city and 'ALL' != city">
            and insp.city = #{city}
        </if>
        <if test="null != conditionType and '' != conditionType and 'ALL' != conditionType">
            and info.condition_type = #{conditionType}
        </if>
        <if
                test="null != customerType and '' != customerType and 'ALL' != customerType">
            and info.customertype = #{customerType}
        </if>
        <if test="null != pdtversion and '' != pdtversion and 'ALL' != pdtversion">
            and t.version = #{pdtversion}
        </if>
        <if test="null != source and '' != source and 'ALL' != source">
            and t.source = #{source}
        </if>
        <if test="null != typeInput and '' != typeInput ">
            and c.type like '%' ||#{typeInput}||'%'
        </if>
        <if test="null != siteInput and '' != siteInput ">
            and insp.site like '%' ||#{siteInput}||'%'
        </if>
        group by c.type
        <!-- 	 )tt
        <![CDATA[
            where rownum<=#{end})
            where r > #{start}
        ]]> -->
    </select>

    <!-- 客户用到，测试未测到  -->
    <!-- <select id="getTotal2" resultType="java.lang.Integer">
        select count(1) from (
        select count(1)
          from t_cube_ens_business c
         inner join t_cube_ens_insp insp on c.fk_insp = insp.guid
         inner join  ebg_custorem_record_info info on info.customer_name = insp.site
          left join t_scenes_test_business t on c.type = t.type
         where t.type is null
           <if test="null != pdu and '' != pdu and 'ALL' != pdu">
                and insp.pdu = #{pdu}
            </if>
            <if test="null != site and '' != site and 'ALL' != site">
                and insp.SITE = #{site}
            </if>
            <if test="null != area and '' != area and 'ALL' != area">
                and insp.area = #{area}
            </if>
            <if test="null != city and '' != city and 'ALL' != city">
                and insp.city = #{city}
            </if>
            <if test="null != conditionType and '' != conditionType and 'ALL' != conditionType">
                and info.condition_type = #{conditionType}
            </if>
 <if
                test="null != customerType and '' != customerType and 'ALL' != customerType">
                and info.customertype = #{customerType}
            </if>
         group by c.type
         )tt
    </select> -->
    <!-- 客户用到，测试未测到  -->
    <select id="getBusinessList2" resultType="com.huawei.z00448113.vo.businesscontrast.BusinessInforRVO">
        <!-- select *
        from (select rownum r, tt.*
        from ( -->
        select c.type,
        min(to_number(c.value)) customerMinValue,
        max(to_number(c.value)) customerMaxValue,
        min(to_number(t.value)) testMinValue,
        max(to_number(t.value)) testMaxValue
        from t_cube_ens_business c
        inner join t_cube_ens_insp insp on c.fk_insp = insp.guid
        inner join  ebg_custorem_record_info info on info.customer_name = insp.site
        left join t_scenes_test_business t on c.type = t.type
        where t.type is null
        and regexp_like(c.value,'^[0-9]+([.]{1}[0-9]+){0,1}$')
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and insp.pdu = #{pdu}
        </if>
        <if test="null != site and '' != site and 'ALL' != site">
            and insp.alias = #{site}
        </if>
        <if test="null != area and '' != area and 'ALL' != area">
            and insp.area = #{area}
        </if>
        <if test="null != city and '' != city and 'ALL' != city">
            and insp.city = #{city}
        </if>
        <if test="null != conditionType and '' != conditionType and 'ALL' != conditionType">
            and info.condition_type = #{conditionType}
        </if>
        <if
                test="null != customerType and '' != customerType and 'ALL' != customerType">
            and info.customertype = #{customerType}
        </if>
        <if test="null != typeInput and '' != typeInput ">
            and c.type like '%' ||#{typeInput}||'%'
        </if>
        <if test="null != siteInput and '' != siteInput ">
            and insp.site like '%' ||#{siteInput}||'%'
        </if>
        group by c.type
        <!-- 	 )tt
       <![CDATA[
           where rownum<=#{end})
           where r > #{start}
       ]]> -->
    </select>

    <select id="getBusinessList3" resultType="com.huawei.z00448113.vo.businesscontrast.BusinessInforRVO">
        <!-- select *
        from (select rownum r, tt.*
        from ( -->
        select t.type,
        min(to_number(c.value)) customerMinValue,
        max(to_number(c.value)) customerMaxValue,
        min(to_number(t.value)) testMinValue,
        max(to_number(t.value)) testMaxValue
        from t_scenes_test_business t
        left join t_cube_ens_business c on c.type = t.type
        where c.type is null
        and regexp_like(t.value,'^[0-9]+([.]{1}[0-9]+){0,1}$')
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and t.pdu = #{pdu}
        </if>
        <if test="null != pdtversion and '' != pdtversion and 'ALL' != pdtversion">
            and t.version = #{pdtversion}
        </if>
        <if test="null != source and '' != source and 'ALL' != source">
            and t.source = #{source}
        </if>
        <if test="null != typeInput and '' != typeInput ">
            and t.type like '%' ||#{typeInput}||'%'
        </if>
        group by t.type
        <!-- )tt
       <![CDATA[
           where rownum<=#{end})
           where r > #{start}
       ]]> -->
    </select>

    <!-- 客户用到的指标列表 -->
    <select id="getCustomerCount" resultType="java.lang.Integer">
        select count(1) from
        (
        select distinct b.type , b.cmd , b.value,
        insp.alias site,max(insp.rowkey)
        from  t_cube_ens_business b,
        t_cube_ens_insp insp
        <if test="null != scene_id and '' != scene_id ">
            ,ebg_customer_scene_site s
        </if>
        where b.fk_insp=insp.guid
        <if test="null != scene_id and '' != scene_id ">
            and s.site =insp.site
            and s.scene_id = #{scene_id}
        </if>
        <if test="null != siteInput and '' != siteInput ">
            and insp.site like '%' ||#{siteInput}||'%'
        </if>
        and insp.pdu = #{pdu}
        and regexp_like(b.value,'^[0-9]+([.]{1}[0-9]+){0,1}$')
        and b.type = #{type}
        group by b.type , b.cmd , b.value,insp.alias
        ) e
    </select>
    <select id="getCustomerValue" resultType="com.huawei.z00448113.vo.businesscontrast.BusinessInforRVO">
        select *
        from (select rownum r, tt.*
        from (
        select distinct b.type , b.cmd , b.value,
        insp.alias site,max(insp.rowkey) rowkey
        from  t_cube_ens_business b,
        t_cube_ens_insp insp
        <if test="null != scene_id and '' != scene_id ">
            ,ebg_customer_scene_site s
        </if>
        where b.fk_insp=insp.guid
        <if test="null != scene_id and '' != scene_id ">
            and s.site =insp.site
            and s.scene_id = #{scene_id}
        </if>
        <if test="null != siteInput and '' != siteInput ">
            and insp.site like '%' ||#{siteInput}||'%'
        </if>
        and insp.pdu = #{pdu}
        and regexp_like(b.value,'^[0-9]+([.]{1}[0-9]+){0,1}$')
        and b.type = #{type}
        group by b.type , b.cmd , b.value,insp.alias
        order by b.type,insp.alias, to_number(b.value)

        )tt
        <![CDATA[
		where rownum<=#{end})
		where r > #{start}
	]]>
    </select>

    <!-- 测试数据用到的指标列表 -->
    <select id="getTestCount" resultType="java.lang.Integer">
        select count(1) from (
        select distinct b.type , b.cmd , b.value ,to_char(b.time, 'yyyy-mm-dd') time,b.rowkey,b.version pdtversion
        from  t_scenes_test_business b
        where b.pdu = #{pdu}
        and regexp_like(b.value,'^[0-9]+([.]{1}[0-9]+){0,1}$')
        and b.type = #{type}
        order by b.type , b.version, to_number(b.value)
        ) e
    </select>
    <select id="getTestValue" resultType="com.huawei.z00448113.vo.businesscontrast.BusinessInforRVO">
        select *
        from (select rownum r, tt.*
        from (
        select distinct b.type , b.cmd , b.value ,to_char(b.time, 'yyyy-mm-dd') time,b.rowkey,b.version pdtversion
        from  t_scenes_test_business b
        where b.pdu = #{pdu}
        and regexp_like(b.value,'^[0-9]+([.]{1}[0-9]+){0,1}$')
        and b.type = #{type}
        order by b.type , b.version, to_number(b.value)
        )tt
        <![CDATA[
		where rownum<=#{end})
		where r > #{start}
	]]>
    </select>

    <!-- 获取所有导出excel -->
    <select id="getAllBusines" resultType="com.huawei.z00448113.vo.businesscontrast.BusinessInforRVO">
        select c.type,
        min(to_number(c.value)) customerMinValue,
        max(to_number(c.value)) customerMaxValue,
        min(to_number(t.value)) testMinValue,
        max(to_number(t.value)) testMaxValue
        from t_cube_ens_business      c,
        t_scenes_test_business   t,
        t_cube_ens_insp          insp,
        ebg_custorem_record_info info
        where c.type = t.type
        and c.fk_insp = insp.guid
        and insp.pdu = info.product
        and info.customer_name = insp.site
        and insp.pdu = t.pdu
        and  regexp_like(c.value,'^[0-9]+([.]{1}[0-9]+){0,1}$')
        and  regexp_like(t.value,'^[0-9]+([.]{1}[0-9]+){0,1}$')
        and insp.pdu = #{pdu}
        group by c.type

        union all

        select c.type,
        min(to_number(c.value)) customerMinValue,
        max(to_number(c.value)) customerMaxValue,
        min(to_number(t.value)) testMinValue,
        max(to_number(t.value)) testMaxValue
        from t_cube_ens_business c
        inner join t_cube_ens_insp insp on c.fk_insp = insp.guid
        inner join  ebg_custorem_record_info info on info.customer_name = insp.site
        left join t_scenes_test_business t on c.type = t.type
        where t.type is null
        and  regexp_like(c.value,'^[0-9]+([.]{1}[0-9]+){0,1}$')
        and insp.pdu = #{pdu}
        group by c.type

        union all

        select t.type,
        min(to_number(c.value)) customerMinValue,
        max(to_number(c.value)) customerMaxValue,
        min(to_number(t.value)) testMinValue,
        max(to_number(t.value)) testMaxValue
        from t_scenes_test_business t
        left join t_cube_ens_business c on c.type = t.type
        where c.type is null
        and regexp_like(t.value,'^[0-9]+([.]{1}[0-9]+){0,1}$')
        and t.pdu = #{pdu}
        group by t.type

    </select>

</mapper>

<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="com.huawei.z00448113.dao.CmdEvaluationDao">

    <!-- 覆盖趋势图-->
    <select id="getMaxTrend" resultType="com.huawei.z00448113.vo.allcontrastvo.TrendPo">
        select * from (
        select t.testcover testCover,t.usertotal userTotal
        from t_test_cmd_datecover t
        where t.checktime  &lt;= to_date(#{selectDate},'yyyy-mm-dd')
        and t.pdu = #{pdu}
        and t.pdt_version = #{sitVersion}
        and t.source = #{source}
        order by t.checktime desc
        )
        where rownum = 1
    </select>

    <!-- 获得版本下拉框的值 -->
    <select id="getVersionList" resultType="com.huawei.common.entity.vo.InfoPo">
        select distinct VERSION as name from (select pdu,version from t_cube_ens_cmd
        union all
        select pdu, pdt_version as version from t_scenes_test_datainfo)
        where 1=1
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and pdu = #{pdu}
        </if>
        order by VERSION desc
    </select>

    <!-- 获得产品下拉框的值 -->
    <select id="getProductList" resultType="com.huawei.common.entity.vo.InfoPo">
        select distinct PRODUCT as name from <choose>
        <when test = "isNewVersion">
            t_ens_cli_base
        </when>
        <otherwise>
            t_cube_ens_cmd
        </otherwise>
    </choose>
        where 1=1
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and pdu = #{pdu}
        </if>
        <if test="null != sitVersion and '' != sitVersion and 'ALL' != sitVersion">
            and VERSION = #{sitVersion}
        </if>
        order by PRODUCT
    </select>

    <!--来源下拉框-->
    <select id="getSourceList" resultType="com.huawei.common.entity.vo.InfoPo">
        select distinct source as
        name from T_CC_ENS_MATCH
    </select>

    <!-- 获得下拉框的值 -->
    <select id="getSubSysList" resultType="com.huawei.common.entity.vo.InfoPo">
        select distinct b.SUBSYS as name from <choose>
        <when test = "isNewVersion">
            t_ens_cli_base
        </when>
        <otherwise>
            t_cube_ens_cmd
        </otherwise>
    </choose> b
        where 1=1
        <if test="null != sitVersion and '' != sitVersion and 'ALL' != sitVersion">
            and VERSION = #{sitVersion}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and pdu = #{pdu}
        </if>
        order by b.SUBSYS
    </select>

    <!-- 获取命令行总数 -->
    <select id="getCmdTotal" resultType="java.lang.Integer">
        select nvl(count(*),0)
        from <choose>
        <when test = "isNewVersion">
            t_ens_cli_base
        </when>
        <otherwise>
            t_cube_ens_cmd
        </otherwise>
    </choose> b
        <if test="null != condition and '' != condition and 'ALL' != condition">
            ,T_CUBE_ENS_INSP insp,T_CUBE_ENS_NE_CMD ne
        </if>
        where 1=1
        <if test="null != condition and '' != condition and 'ALL' != condition">
            and ne.fk_cmd = b.guid
            and ne.FK_INSP = insp.guid
            and
            insp.condition =#{condition}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and b.pdu = #{pdu}
        </if>
        <if test="null != sitVersion and '' != sitVersion and 'ALL' != sitVersion">
            and b.version = #{sitVersion}
        </if>
        <if test="null != sitProduct and '' != sitProduct and 'ALL' != sitProduct">
            and b.product = #{sitProduct}
        </if>
        <if test="null != subsys and '' != subsys and 'ALL' != subsys">
            and b.subsys = #{subsys}
        </if>
    </select>

    <!-- 获取用户使用行总数 -->
    <select id="getCustomCmdTotal" resultType="java.lang.Integer">
        select nvl(count(distinct b.GUID),0)
        from T_CUBE_ENS_NE_CMD u,<choose>
        <when test = "isNewVersion">
            t_ens_cli_base
        </when>
        <otherwise>
            t_cube_ens_cmd
        </otherwise>
    </choose>
        b, T_CUBE_ENS_INSP nb
        ,ebg_custorem_record_info info
        ,T_CUBE_ENS_NE ne
        where u.FK_CMD=b.GUID
        and u.FK_INSP=nb.GUID
        and
        nb.site=info.customer_name
        and nb.fk_ne = ne.guid
        and ne.checktype=','
        and info.delflag = 0
        <if test="'ESAP' != pdu">
            and nb.pdu=info.product
        </if>
        <if test="version != null and '' != version and 'ALL' != version">
            and nb.PT_RVERSION=#{version}
        </if>
        <if test="null != productList and productList.size() != 0">
            and nb.PRODUCT in
            <foreach collection="productList" item="pro" open="("
                     separator="," close=")">
                #{pro}
            </foreach>
        </if>
        <if test="null != region and '' != region and 'ALL' != region">
            and nb.AREA=#{region}
        </if>
        <if test="null != site and '' != site and 'ALL' != site">
            and nb.alias = #{site}
        </if>
        <if test="sitVersion != null and '' != sitVersion and 'ALL' != sitVersion">
            and b.VERSION=#{sitVersion}
        </if>
        <if test="null != sitProduct and '' != sitProduct and 'ALL' != sitProduct">
            and b.PRODUCT=#{sitProduct}
        </if>
        <if test="null != subsys and '' != subsys and 'ALL' != subsys">
            and b.SUBSYS=#{subsys}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and b.pdu = #{pdu}
        </if>
        <if test="null != condition and '' != condition and 'ALL' != condition">
            and nb.condition = #{condition}
        </if>
    </select>

    <!-- 获取测试命令行总数 -->
    <select id="getTestCmdTotal" resultType="Integer">
        select nvl(count(distinct b.guid),0)
        from T_CC_ENS_MATCH t,<choose>
        <when test = "isNewVersion">
            t_ens_cli_base
        </when>
        <otherwise>
            t_cube_ens_cmd
        </otherwise>
    </choose> b
        <if test="null != condition and '' != condition and 'ALL' != condition">
            ,T_CUBE_ENS_INSP insp,T_CUBE_ENS_NE_CMD ne
        </if>
        where t.cmd_index = b.cmd_index
        and t.version = b.version
        and t.product = b.product
        <if test="null != condition and '' != condition and 'ALL' != condition">
            and ne.fk_cmd = b.guid
            and ne.FK_INSP = insp.guid
            and insp.condition =#{condition}
        </if>
        <if test="sitVersion != null and '' != sitVersion and 'ALL' != sitVersion">
            and b.version=#{sitVersion}
        </if>
        <if test="null != subsys and '' != subsys and 'ALL' != subsys">
            and b.subsys=#{subsys}
        </if>
        <if test="sitProduct != null and '' != sitProduct and 'ALL' != sitProduct">
            and b.product=#{sitProduct}
        </if>
        <if test="null != source and '' != source and 'ALL' != source">
            and t.source=#{source}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and b.pdu = #{pdu}
        </if>
    </select>

    <!-- 获取三表共有命令行总数 -->
    <select id="getTestUsedTotal" resultType="Integer">
        select
        nvl(count(distinct b.guid),0)
        from T_CC_ENS_MATCH t,
        <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> b,
        T_CUBE_ENS_NE_CMD cmd,
        T_CUBE_ENS_INSP nb,
        T_CUBE_ENS_NE ne,
        ebg_custorem_record_info info
        where cmd.fk_cmd = b.guid
        and cmd.FK_INSP = nb.guid
        <if test="'ESAP' != pdu">
            and cmd.pdu = nb.pdu
        </if>
        and t.cmd_index = b.cmd_index
        and t.product = b.product
        and t.version = b.version
        and nb.fk_ne = ne.guid
        and nb.site=info.customer_name
        and info.delflag=0
        and ne.checktype=','
        <if test="'ESAP' != pdu">
            and nb.pdu=info.product
        </if>
        <if test="null != source and '' != source and 'ALL' != source">
            and t.source=#{source}
        </if>
        <if test="version != null and ''!= version and 'ALL' != version">
            and nb.PT_RVERSION=#{version}
        </if>
        <if test="null != productList and productList.size() != 0">
            and nb.PRODUCT in
            <foreach collection="productList" item="pro" open="("
                     separator="," close=")">
                #{pro}
            </foreach>
        </if>
        <if test="null != region and '' != region and 'ALL' != region">
            and nb.AREA=#{region}
        </if>
        <if test="null != site and '' != site and 'ALL' != site">
            and nb.alias=#{site}
        </if>
        <if test="sitVersion != null and '' != sitVersion and 'ALL' != sitVersion">
            and b.VERSION=#{sitVersion}
        </if>
        <if test="null != sitProduct and '' != sitProduct and 'ALL' != sitProduct">
            and b.PRODUCT=#{sitProduct}
        </if>
        <if test="null != subsys and '' != subsys and 'ALL' != subsys">
            and b.SUBSYS=#{subsys}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
		and b.pdu = #{pdu}
        </if>
        <if test="null != condition and '' != condition and 'ALL' != condition">
            and nb.condition = #{condition}
        </if>
    </select>

    <!-- 配置映射 -->
    <resultMap type="com.huawei.z00448113.po.EvaluationChartPo"
               id="CHART_ORM">
        <result property="count" column="count" />
        <result property="subsys" column="gsubsys" />
    </resultMap>
    <!-- 直方图获取命令行总数 -->
    <select id="getCmdTotalList" resultMap="CHART_ORM">
        select count(distinct b.guid) count, b.subsys gsubsys
        from
        <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> b
        <if test="null != condition and '' != condition and 'ALL' != condition">
            ,T_CUBE_ENS_INSP insp,T_CUBE_ENS_NE_CMD ne
        </if>
        where 1=1
        <if test="null != condition and '' != condition and 'ALL' != condition">
            and ne.fk_cmd = b.guid
            and ne.FK_INSP = insp.guid
            and
            insp.condition =#{condition}
        </if>

        <if test="sitVersion != null and '' != sitVersion and 'ALL' != sitVersion">
            and b.version=#{sitVersion}
        </if>
        <if test="null != sitProduct and '' != sitProduct and 'ALL' != sitProduct">
            and b.product=#{sitProduct}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and b.pdu = #{pdu}
        </if>
        group by b.subsys
    </select>

    <!-- 直方图获取测试命令行总数 -->
    <select id="getTestCmdTotalList" resultMap="CHART_ORM">
        select count(distinct b.guid) count, b.subsys gsubsys
        from
        <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> b, T_CC_ENS_MATCH t
        <if test="null != condition and '' != condition and 'ALL' != condition">
            ,T_CUBE_ENS_INSP insp,T_CUBE_ENS_NE_CMD ne
        </if>
        where b.cmd_index = t.cmd_index
        and b.version = t.version
        and b.product
        = t.product
        <if test="null != condition and '' != condition and 'ALL' != condition">
            and ne.fk_cmd = b.guid
            and ne.FK_INSP = insp.guid
            and
            insp.condition =#{condition}
        </if>
        <if test="null != source and '' != source and 'ALL' != source">
            and t.source=#{source}
        </if>
        <if test="sitVersion != null and '' != sitVersion and 'ALL' != sitVersion">
            and b.version = #{sitVersion}
        </if>
        <if test="null != sitProduct and '' != sitProduct and 'ALL' != sitProduct">
            and b.product=#{sitProduct}
        </if>
        <if test="null != subsys and '' != subsys and 'ALL' != subsys">
            and b.subsys=#{subsys}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and b.pdu = #{pdu}
        </if>
        group by b.subsys
    </select>

    <!-- 直方图获取用户使用行总数 -->
    <select id="getCustomCmdTotalList" resultMap="CHART_ORM">
        select  count(distinct b.guid)
        count,b.subsys gsubsys
        from T_CUBE_ENS_NE_CMD cmd,
        <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> b,
        T_CUBE_ENS_INSP nb
        ,ebg_custorem_record_info info
        ,T_CUBE_ENS_NE ne
        where b.guid = cmd.fk_cmd
        and nb.guid = cmd.FK_INSP
        and
        nb.site=info.customer_name
        and info.delflag = 0
        and nb.fk_ne = ne.guid
        and ne.checktype=','
        <if test="'ESAP' != pdu">
            and nb.pdu=info.product
        </if>
        <if test="version != null and ''!= version and 'ALL' != version">
            and nb.PT_RVERSION=#{version}
        </if>
        <if test="null != productList and productList.size() != 0">
            and nb.PRODUCT in
            <foreach collection="productList" item="pro" open="("
                     separator="," close=")">
                #{pro}
            </foreach>
        </if>
        <if test="null != region and '' != region and 'ALL' != region">
            and nb.area=#{region}
        </if>
        <if test="null != site and '' != site and 'ALL' != site">
            and nb.alias=#{site}
        </if>
        <if test="sitVersion != null and '' != sitVersion and 'ALL' != sitVersion">
            and b.version=#{sitVersion}
        </if>
        <if test="null != sitProduct and '' != sitProduct and 'ALL' != sitProduct">
            and b.product=#{sitProduct}
        </if>
        <if test="null != subsys and '' != subsys and 'ALL' != subsys">
            and b.subsys=#{subsys}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and b.pdu = #{pdu}
        </if>
        <if test="null != condition and '' != condition and 'ALL' != condition">
            and nb.condition = #{condition}
        </if>
        group by b.subsys
    </select>

    <!-- 直方图获取三表共有命令行总数 -->
    <select id="getTestUsedList" resultMap="CHART_ORM">
        select count(distinct b.guid) count,
        b.subsys gsubsys
        from T_CC_ENS_MATCH t,
        <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> b,
        T_CUBE_ENS_NE_CMD cmd,
        T_CUBE_ENS_INSP nb,
        T_CUBE_ENS_NE ne,
        ebg_custorem_record_info info
        where cmd.fk_cmd = b.guid
        and cmd.FK_INSP = nb.guid
        and cmd.pdu = nb.pdu
        and t.cmd_index = b.cmd_index
        and t.version = b.version
        and t.product = b.product
        and nb.fk_ne = ne.guid
        and nb.site=info.customer_name
        and info.delflag = 0
        and ne.checktype=','
        <if test="'ESAP' != pdu">
            and nb.pdu=info.product
        </if>
        <if test="null != source and '' != source and 'ALL' != source">
            and t.source=#{source}
        </if>
        <if test="version != null and ''!= version and 'ALL' != version">
            and nb.PT_RVERSION = #{version}
        </if>
        <if test="null != productList and productList.size() != 0">
            and nb.PRODUCT in
            <foreach collection="productList" item="pro" open="("
                     separator="," close=")">
                #{pro}
            </foreach>
        </if>
        <if test="null != region and '' != region and 'ALL' != region">
            and nb.area = #{region}
        </if>
        <if test="null != site and '' != site and 'ALL' != site">
            and nb.alias=#{site}
        </if>
        <if test="sitVersion != null and '' != sitVersion and 'ALL' != sitVersion">
            and b.version = #{sitVersion}
        </if>
        <if test="null != sitProduct and '' != sitProduct and 'ALL' != sitProduct">
            and b.product=#{sitProduct}
        </if>
        <if test="null != subsys and '' != subsys and 'ALL' != subsys">
            and b.subsys=#{subsys}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and b.pdu = #{pdu}
        </if>
        <if test="null != condition and '' != condition and 'ALL' != condition">
            and nb.condition = #{condition}
        </if>
        group by b.subsys
    </select>

    <select id="getAllFeature" resultType="com.huawei.z00448113.po.EvaluationPo">
        select
        feature,
        subsys,
        count(guid) sitTotal
        from
        <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> b
        where
        1=1
        <if test="pdu != null and '' != pdu and 'ALL' != pdu">
            and pdu = #{pdu}
        </if>
        <if test="sitVersion != null and '' != sitVersion and 'ALL' != sitVersion">
            and b.version = #{sitVersion}
        </if>
        <if test="null != sitProduct and '' != sitProduct and 'ALL' != sitProduct">
            and b.product = #{sitProduct}
        </if>
        <if test="null != subsys and '' != subsys and 'ALL' != subsys">
            and b.subsys=#{subsys}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and b.pdu = #{pdu}
        </if>
        <if test="null != featureInput and '' != featureInput ">
            and b.feature like '%' ||#{featureInput}||'%'
        </if>
        <if test="null != cmdInput and '' != cmdInput ">
            and b.name like '%' ||#{cmdInput}||'%'
        </if>
        group by
        b.feature,
        b.subsys
    </select>

    <select id="getCustomFeature" resultType="com.huawei.z00448113.po.EvaluationPo">
        select
        distinct b.feature,
        b.subsys,
        cmd.fk_cmd guid
        from
        t_cube_ens_ne_cmd cmd,
        <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> b,
 
 
 
 
 
 
 
 
 
 
 
 
 
 


        T_CUBE_ENS_INSP nb,
        ebg_custorem_record_info info,
        T_CUBE_ENS_NE ne
        where
        cmd.FK_INSP=nb.GUID
        and nb.site=info.customer_name
        and nb.fk_ne = ne.guid
        and ne.checktype=','
        and info.delflag = 0
        and cmd.fk_cmd=b.guid
        <if test="'ESAP' != pdu">
            and nb.pdu=info.product
        </if>
        <if test="sitVersion != null and '' != sitVersion and 'ALL' != sitVersion">
            and b.version = #{sitVersion}
        </if>
        <if test="null != sitProduct and '' != sitProduct and 'ALL' != sitProduct">
            and b.product = #{sitProduct}
        </if>
        <if test="null != subsys and '' != subsys and 'ALL' != subsys">
            and b.subsys=#{subsys}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and b.pdu = #{pdu}
        </if>
        <if test="null != featureInput and '' != featureInput ">
            and b.feature like '%' ||#{featureInput}||'%'
        </if>
        <if test="null != cmdInput and '' != cmdInput ">
            and b.name like '%' ||#{cmdInput}||'%'
        </if>
    </select>

    <select id="getSitFeature" resultType="com.huawei.z00448113.po.EvaluationPo">
        select
        distinct b.feature,
        b.subsys,
        b.guid
        from
        t_cc_ens_match m,
        <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> b
        where
        m.cmd_index = b.cmd_index
        and m.product=b.product
        and m.version = b.version
        <if test="null != source and '' != source and 'ALL' != source">
            and m.source=#{source}
        </if>
        <if test="sitVersion != null and '' != sitVersion and 'ALL' != sitVersion">
            and b.version = #{sitVersion}
        </if>
        <if test="null != sitProduct and '' != sitProduct and 'ALL' != sitProduct">
            and b.product = #{sitProduct}
        </if>
        <if test="null != subsys and '' != subsys and 'ALL' != subsys">
            and b.subsys=#{subsys}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and b.pdu = #{pdu}
        </if>
        <if test="null != featureInput and '' != featureInput ">
            and b.feature like '%' ||#{featureInput}||'%'
        </if>
        <if test="null != cmdInput and '' != cmdInput ">
            and b.name like '%' ||#{cmdInput}||'%'
        </if>
    </select>

    <!--命令行二级列表-->
    <select id="getAllGuid" resultType="java.lang.String">
        select
        distinct guid
        from
        <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> b
        where
        1=1
        <if test="pdu != null and '' != pdu and 'ALL' != pdu">
            and b.pdu = #{pdu}
        </if>
        <if test="sitVersion != null and '' != sitVersion and 'ALL' != sitVersion">
            and b.version = #{sitVersion}
        </if>
        <if test="null != sitProduct and '' != sitProduct and 'ALL' != sitProduct">
            and b.product = #{sitProduct}
        </if>
        <if test="null != selectSubSys and '' != selectSubSys and 'ALL' != selectSubSys">
            and b.subsys=#{selectSubSys}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and b.pdu = #{pdu}
        </if>
        <if test="null != selectFeature and '' != selectFeature ">
            and b.feature = #{selectFeature}
        </if>
        <if test="null != cmdInput and '' != cmdInput ">
            and b.name like '%' ||#{cmdInput}||'%'
        </if>
    </select>

    <!--命令行二级列表,客户覆盖的命令行-->
    <select id="getCustomGuid" resultType="java.lang.String">
        select
        distinct cmd.fk_cmd guid
        from
        t_cube_ens_ne_cmd cmd,
        <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> b,
        T_CUBE_ENS_INSP nb,
        ebg_custorem_record_info info,
        T_CUBE_ENS_NE ne
        where
        cmd.FK_INSP=nb.GUID
        and nb.site=info.customer_name
        and nb.fk_ne = ne.guid
        and ne.checktype=','
        and info.delflag = 0
        and cmd.fk_cmd=b.guid
        <if test="'ESAP' != pdu">
            and nb.pdu=info.product
        </if>
        <if test="sitVersion != null and '' != sitVersion and 'ALL' != sitVersion">
            and b.version = #{sitVersion}
        </if>
        <if test="null != sitProduct and '' != sitProduct and 'ALL' != sitProduct">
            and b.product = #{sitProduct}
        </if>
        <if test="null != subsys and '' != subsys and 'ALL' != subsys">
            and b.subsys=#{subsys}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and b.pdu = #{pdu}
        </if>
        <if test="null != selectFeature and '' != selectFeature ">
            and b.feature = #{selectFeature}
        </if>
        <if test="null != cmdInput and '' != cmdInput ">
            and b.name like '%' ||#{cmdInput}||'%'
        </if>
    </select>

    <!--命令行二级列表,测试覆盖的命令行-->
    <select id="getSitGuid" resultType="java.lang.String">
        select
        b.guid
        from
        t_cc_ens_match m,
        <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> b
        where
        m.cmd_index = b.cmd_index
        and m.product = b.product
        and m.version = b.version
        <if test="null != source and '' != source and 'ALL' != source">
            and m.source=#{source}
        </if>
        <if test="sitVersion != null and '' != sitVersion and 'ALL' != sitVersion">
            and b.version = #{sitVersion}
        </if>
        <if test="null != sitProduct and '' != sitProduct and 'ALL' != sitProduct">
            and b.product = #{sitProduct}
        </if>
        <if test="null != subsys and '' != subsys and 'ALL' != subsys">
            and b.subsys=#{subsys}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and b.pdu = #{pdu}
        </if>
        <if test="null != selectFeature and '' != selectFeature ">
            and b.feature = #{selectFeature}
        </if>
        <if test="null != cmdInput and '' != cmdInput ">
            and b.name like '%' ||#{cmdInput}||'%'
        </if>
    </select>

    <!-- 获取二级列表 -->
    <select id="getCmdRootList" resultType="com.huawei.z00448113.po.CmdRiskPo">
        select b.guid,
	     <!-- b.cmd_index, -->
        b.product product,
        b.name cmdName,
        b.view_mode viewMode,
        b.feature feature,
        b.subsys subsys,
        b.version
        from
        <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> b
        where b.guid = #{selectGuid}
        and b.feature = #{selectFeature}
        and b.subsys = #{selectSubsys}
    </select>

    <!-- 2级列表客户使用次数 -->
    <select id="getCustomUseNum" resultType="Integer">
        select nvl(sum(cmd.mtime),0) usum
        from
        <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> b,
        t_cube_ens_ne_cmd cmd
        where cmd.fk_cmd=b.guid
        and b.guid = #{selectGuid}
    </select>

    <!-- 2级列表客测试使用次数 -->
    <select id="getSitUseNum" resultType="Integer">
        select nvl(sum(m.match_time),0) tsum
        from
        <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> b,
        t_cc_ens_match m
        where m.cmd_index=b.cmd_index
        and m.version=b.version
        and m.product=b.product
        and b.guid = #{selectGuid}
    </select>

    <select id='getSite4Po' resultType='java.lang.String'>
        select distinct nb.alias as site from T_CUBE_ENS_INSP nb,<choose>
        <when test = "isNewVersion">
            t_ens_cli_base
        </when>
        <otherwise>
            t_cube_ens_cmd
        </otherwise>
    </choose>
        e,T_CUBE_ENS_NE_CMD u,t_cube_ENS_ne ne
        where e.guid = u.fk_cmd
        and
        nb.guid = u.FK_INSP
        and e.guid = #{guid}
        and nb.fk_ne = ne.guid(+)
        <if test='null != guid  and !"".equals(guid)'>
            and u.fk_cmd=#{guid}
            and instr(ne.checktype,','||(select
            view_mode from <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> where
            guid=#{guid})||',')=0
        </if>
    </select>

    <!-- 获取指定命令行下网元数量 -->
    <select id="getNeSize" resultType="Integer">
        select count(*) from
        (select distinct ne.name name,
        insp.guid GUID,
        insp.area area,
        insp.city city,
        insp.alias site,
        insp.PT_RVERSION version,
        insp.product product,
        insp.rowkey rowKey,
        to_char(insp.time,
        'yyyy-mm-dd') time
        from t_cube_ENS_ne_cmd nc,
        T_CUBE_ENS_INSP insp ,
        t_cube_ENS_ne ne
        <if test="('' != scene and 'ALL' != scene and null != scene) or ('' != subScene and 'ALL' != subScene and null != subScene)">
            ,ebg_custorem_scene cs
        </if>
        where
        1=1
        <if  test="('' != scene and 'ALL' != scene and null != scene) or ('' != subScene and 'ALL' != subScene and null != subScene)">
            and insp.subscene = cs.subscene
        </if>
        and nc.FK_INSP = insp.guid
        and insp.fk_ne = ne.guid(+)
        <if test="null != inspGuidList and inspGuidList.size() != 0">
            and insp.guid in
            <foreach collection="inspGuidList" item="pro" open="("
                     separator="," close=")">
                #{pro}
            </foreach>
        </if>
        <if test='null != guid  and !"".equals(guid)'>
            and nc.fk_cmd=#{guid}
            and instr(ne.checktype,','||(select
            view_mode from <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> where
            guid=#{guid})||',')=0
        </if>
        <if test="version != null and '' != version and 'ALL' != version">
            and insp.PT_RVERSION=#{version}
        </if>
        <if test="null != productList and productList.size() != 0">
            and insp.PRODUCT in
            <foreach collection="productList" item="pro" open="("
                     separator="," close=")">
                #{pro}
            </foreach>
        </if>
        <if test="null != region and '' != region and 'ALL' != region">
            and insp.area=#{region}
        </if>
        <if test="null != site and '' != site and 'ALL' != site">
            and insp.alias=#{site}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and insp.pdu = #{pdu}
        </if>
        <if test="null != condition and '' != condition and 'ALL' != condition">
            and insp.condition = #{condition}
        </if>
        <if test="null != scene and '' != scene and 'ALL' != scene">
            and cs.scene = #{scene}
        </if>
        <if test="null != subScene and '' != subScene and 'ALL' != subScene">
            and insp.subscene = #{subScene}
        </if>
        )
    </select>


    <!--3级,获得命令行网元数据列表 -->
    <select id="getCmdNeList" resultType="com.huawei.z00448113.po.EvaluationPo">
        select * from
        (select rownum r,e.* from
        (select distinct ne.name name,
        insp.guid GUID,
        insp.area area,
        insp.city city,
        insp.alias site,
        insp.PT_RVERSION version,
        insp.product product,
        insp.rowkey rowKey,
        to_char(insp.time, 'yyyy-mm-dd') time
        from t_cube_ENS_ne_cmd nc,
        T_CUBE_ENS_INSP insp ,
        t_cube_ENS_ne ne
        <if test="('' != scene and 'ALL' != scene and null != scene) or ('' != subScene and 'ALL' != subScene and null != subScene)">
            ,ebg_custorem_scene cs
        </if>

        where 1=1
        <if test="('' != scene and 'ALL' != scene and null != scene) or ('' != subScene and 'ALL' != subScene and null != subScene)">
            and insp.subscene = cs.subscene
        </if>
        and nc.FK_INSP = insp.guid
        and insp.fk_ne = ne.guid(+)
        <if test="null != inspGuidList and inspGuidList.size() != 0">
            and insp.guid in
            <foreach collection="inspGuidList" item="pro" open="("
                     separator="," close=")">
                #{pro}
            </foreach>
        </if>
        <if test='null != guid  and !"".equals(guid)'>
            and nc.fk_cmd=#{guid}
            and instr(ne.checktype,','||(select
            view_mode from <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> where
            guid=#{guid})||',')=0
        </if>
        <if test="version != null and '' != version and 'ALL' != version">
            and insp.PT_RVERSION=#{version}
        </if>
        <if test="null != productList and productList.size() != 0">
            and insp.PRODUCT in
            <foreach collection="productList" item="pro" open="("
                     separator="," close=")">
                #{pro}
            </foreach>
        </if>
        <if test="null != region and '' != region and 'ALL' != region">
            and insp.area=#{region}
        </if>
        <if test="null != site and '' != site and 'ALL' != site">
            and insp.alias=#{site}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and insp.pdu = #{pdu}
        </if>
        <if test="null != condition and '' != condition and 'ALL' != condition">
            and insp.condition = #{condition}
        </if>
        <if test="null != scene and '' != scene and 'ALL' != scene">
            and cs.scene = #{scene}
        </if>
        <if test="null != subScene and '' != subScene and 'ALL' != subScene">
            and insp.subscene = #{subScene}
        </if>
        ) e
        <![CDATA[
			where rownum<=#{end})
		where r > #{start}
        ]]>
    </select>

    <!--Command详情-->
    <select id="getCmdCommandList" resultType="java.lang.String">
        select nc.match
        from t_cube_ENS_ne_cmd nc,T_CUBE_ENS_INSP
        insp,t_cube_ENS_ne ne
        where 1=1
        and nc.FK_INSP=insp.guid
        and insp.fk_ne =
        ne.guid(+)
        <if test='null != guid  and !"".equals(guid)'>
            and nc.fk_cmd=#{guid}
            and instr(ne.checktype,','||(select
            view_mode from <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> where guid=#{guid})||',')=0
        </if>
        <if test="version != null and '' != version and 'ALL' != version">
            and insp.PT_RVERSION=#{version}
        </if>
        <if test="null != productList and productList.size() != 0">
            and insp.PRODUCT in
            <foreach collection="productList" item="pro" open="("
                     separator="," close=")">
                #{pro}
            </foreach>
        </if>
        <if test="null != region and '' != region and 'ALL' != region">
            and insp.area=#{region}
        </if>
        <if test="null != site and '' != site and 'ALL' != site">
            and insp.alias=#{site}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and insp.pdu = #{pdu}
        </if>
        <if test="null != condition and '' != condition and 'ALL' != condition">
            and insp.condition = #{condition}
        </if>
    </select>

    <!--param详情-->
    <select id="getParamList" resultType="java.lang.String">
        select param_value from
        (select rownum r,e.param_value param_value
        from
        (select nc.param_value
        from t_cube_ENS_ne_cmd nc,T_CUBE_ENS_INSP
        insp,t_cube_ENS_ne ne
        where 1=1
        and nc.FK_INSP=insp.guid
        and insp.fk_ne =
        ne.guid(+)
        <if test='null != guid  and !"".equals(guid)'>
            and nc.fk_cmd=#{guid}
            and instr(ne.checktype,','||(select
            view_mode from <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> where
            guid=#{guid})||',')=0
        </if>
        <if test="version != null and '' != version and 'ALL' != version">
            and insp.PT_RVERSION=#{version}
        </if>
        <if test="null != productList and productList.size() != 0">
            and insp.PRODUCT in
            <foreach collection="productList" item="pro" open="("
                     separator="," close=")">
                #{pro}
            </foreach>
        </if>
        <if test="null != region and '' != region and 'ALL' != region">
            and insp.area=#{region}
        </if>
        <if test="null != site and '' != site and 'ALL' != site">
            and insp.alias=#{site}
        </if>
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and insp.pdu = #{pdu}
        </if>
        <if test="null != condition and '' != condition and 'ALL' != condition">
            and insp.condition = #{condition}
        </if>
        ) e
        <![CDATA[
		where rownum<=100)
		where r > 0
        ]]>
    </select>

    <!-- export,风险分析数据查询 无分页 -->
    <select id="getCmdRiskListAll" resultType="com.huawei.z00448113.po.CmdRiskPo">
        select tt.guid,
        tt.usum userCount,
        tt.tsum testCount,
        ee.product product,
        ee.name cmdName,
        ee.view_mode viewMode,
        ee.feature feature,
        ee.subsys subsys,
        ee.version
        from <choose>
        <when test = "isNewVersion">
            t_ens_cli_base
        </when>
        <otherwise>
            t_cube_ens_cmd
        </otherwise>
    </choose> ee,
        (select ue.guid, ue.usum, te.tsum
        from (
        select distinct e.guid, sum(u.mtime) usum
        from T_CUBE_ENS_NE_CMD u
        ,<choose>
        <when test = "isNewVersion">
            t_ens_cli_base
        </when>
        <otherwise>
            t_cube_ens_cmd
        </otherwise>
    </choose> e
        , T_CUBE_ENS_INSP nb
        ,ebg_custorem_record_info info
        ,T_CUBE_ENS_NE ne
        where u.FK_CMD=e.GUID
        and u.FK_INSP=nb.GUID
        and nb.site=info.customer_name
        and nb.fk_ne = ne.guid
        and ne.checktype=','
        AND info.delflag = 0
        and nb.pdu = info.product
        and e.pdu = #{pdu}
        <if test="sitVersion != null and '' != sitVersion and 'ALL' != sitVersion">
            and e.version = #{sitVersion}
        </if>
        <if test="selectSubSys != null and '' != selectSubSys">
            and e.subsys = #{selectSubSys}
        </if>
        <if test="null != sitProduct and '' != sitProduct and 'ALL' != sitProduct">
            and e.product = #{sitProduct}
        </if>
        group by e.guid) ue
        left join (select distinct e.guid, sum(t.match_time) tsum
        from <choose>
        <when test = "isNewVersion">
            t_ens_cli_base
        </when>
        <otherwise>
            t_cube_ens_cmd
        </otherwise>
    </choose> e, T_CC_ENS_MATCH t
        where e.cmd_index = t.cmd_index
        and e.product = t.product
        and e.version = t.version
        and e.pdu = #{pdu}
        <if test="null != source and '' != source and 'ALL' != source">
            and t.source=#{source}
        </if>
        <if test="sitVersion != null and '' != sitVersion and 'ALL' != sitVersion">
            and e.version = #{sitVersion}
        </if>
        <if test="selectSubSys != null and '' != selectSubSys">
            and e.subsys = #{selectSubSys}
        </if>
        <if test="null != sitProduct and '' != sitProduct and 'ALL' != sitProduct">
            and e.product = #{sitProduct}
        </if>
        group by e.guid) te on ue.guid = te.guid) tt
        where ee.guid = tt.guid
        order by usum desc, tsum desc
    </select>

    <!-- 风险分析数据查询 分页查询 -->
    <select id="getCmdRiskPageList" resultType="com.huawei.z00448113.po.CmdRiskPo">
        select * from
        (select rownum r, t.* from (
        select distinct e.guid guid
        ,e.name name,e.view_mode viewMode,
        (select count(t.guid)
        from
        T_CC_ENS_MATCH t
        where e.cmd_index = t.cmd_index
        and e.version = t.version
        and e.product= t.product
        <if test="null != source and '' != source and 'ALL' != source">
            and t.source=#{source}
        </if>
        <if test="null != scene and '' != scene and 'ALL' != scene">
            and t.origin_scene = #{scene}
        </if>
        <if test="null != subScene and '' != subScene and 'ALL' != subScene">
            and t.origin_subscene = #{subScene}
        </if>

        ) testCount,
        (select count(distinct ne.guid)
        from t_cube_ENS_ne
        ne,T_CUBE_ENS_NE_CMD u ,T_CUBE_ENS_INSP insp
        where e.guid = u.fk_cmd
        and insp.fk_ne = ne.guid
        and u.fk_insp = insp.guid
        <if test="null != pdu and '' != pdu and 'ALL' != pdu">
            and ne.pdu = #{pdu}
        </if>
        <if test="null != subScene and '' != subScene and 'ALL' != subScene">
            and insp.subscene = #{subScene}
        </if>
        <if test="null != inspGuidList and inspGuidList.size() != 0">
            and insp.guid in
            <foreach collection="inspGuidList" item="pro" open="("
                     separator="," close=")">
                #{pro}
            </foreach>
        </if>
        ) userCount
        from <choose>
            <when test = "isNewVersion">
                t_ens_cli_base
            </when>
            <otherwise>
                t_cube_ens_cmd
            </otherwise>
        </choose> e left join
        (
        select ncmd.fk_cmd
        cmd,nb.fk_ne fk_ne_id from
        T_CUBE_ENS_INSP nb,T_CUBE_ENS_NE_CMD ncmd
        <if test="('' != scene and 'ALL' != scene and null != scene) or ('' != subscene and 'ALL' != subscene and null != subscene) ">
            ,ebg_custorem_scene cs
        </if>
        where 1=1 and ncmd.FK_INSP = nb.guid
        <if test="('' != scene and 'ALL' != scene and null != scene) or ('' != subScene and 'ALL' != subScene and null != subScene) ">
            and nb.subscene = cs.subscene
        </if>
        <if test="version != null and '' != version and 'ALL' != version">
            and nb.PT_RVERSION=#{version}
        </if>
        <if test="null != productList and productList.size() != 0">
            and nb.PRODUCT in
            <foreach collection="productList" item="pro" open="("
