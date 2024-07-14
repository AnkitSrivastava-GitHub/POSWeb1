using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_ClockInOutReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["EmpAutoId"] == null)
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx", false);
        }
        else
        {
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/ClockInOutReport.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindClockInOutReport(string dataValues)
    {
        global::DLLClockInOutReport.PL_ClockInOut pobj = new global::DLLClockInOutReport.PL_ClockInOut();
        try
        {
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.EmpId = Convert.ToInt32(jdv["EmpAutoId"]);
                if (jdv["FromDate"] != null && jdv["FromDate"] != "")
                {
                    pobj.FromDate = Convert.ToDateTime(jdv["FromDate"]);
                }
                if (jdv["ToDate"] != null && jdv["ToDate"] != "")
                {
                    pobj.ToDate = Convert.ToDateTime(jdv["ToDate"]);
                }
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                global::DLLClockInOutReport.BL_ClockInOut.BindClockInOutReport(pobj);
                if (pobj.isException != true)
                {
                    return pobj.Ds.GetXml();
                }
                else
                {
                    return "false";
                }
            }
            else
            {
                return "Session";
            }
        }
        catch (Exception ex)
        {
            pobj.isException = true;
            pobj.exceptionMessage = ex.Message;
            return "false";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindEmployeeList()
    {
        global::DLLClockInOutReport.PL_ClockInOut pobj = new global::DLLClockInOutReport.PL_ClockInOut();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                global::DLLClockInOutReport.BL_ClockInOut.BindEmployeeList(pobj);
                if (pobj.isException != true)
                {
                    return pobj.Ds.GetXml();
                }
                else
                {
                    return "false";
                }
            }
            else
            {
                return "Session";
            }
        }
        catch (Exception ex)
        {
            pobj.isException = true;
            pobj.exceptionMessage = ex.Message;
            return "false";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindHourlyRateReport(string dataValues)
    {
        global::DLLClockInOutReport.PL_ClockInOut pobj = new global::DLLClockInOutReport.PL_ClockInOut();
        try
        {
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.EmpId = Convert.ToInt32(jdv["EmpAutoId"]);
                if (jdv["FromDate"] != null && jdv["FromDate"] != "")
                {
                    pobj.FromDate = Convert.ToDateTime(jdv["FromDate"]);
                }
                if (jdv["ToDate"] != null && jdv["ToDate"] != "")
                {
                    pobj.ToDate = Convert.ToDateTime(jdv["ToDate"]);
                }
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                global::DLLClockInOutReport.BL_ClockInOut.BindHourlyRateReport(pobj);
                if (pobj.isException != true)
                {
                    return pobj.Ds.GetXml();
                }
                else
                {
                    return "false";
                }
            }
            else
            {
                return "Session";
            }
        }
        catch (Exception ex)
        {
            pobj.isException = true;
            pobj.exceptionMessage = ex.Message;
            return "false";
        }
    }
}