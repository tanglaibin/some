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
