using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.Services;
using System.Web.Script.Serialization;
using TerminalLoginReport;


public partial class Pages_TerminalLoginReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["EmpAutoId"] != null)
        {
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/TerminalLoginReport.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
        else
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx", false);
        }
    }
    [WebMethod(EnableSession = true)]
    public static string BindTerminal()
    {
        PL_TerminalReport pobj = new PL_TerminalReport();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_TerminalReport.BindTerminal(pobj);
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
    public static string BindTerminalList(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_TerminalReport pobj = new PL_TerminalReport();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {

                pobj.TerminalId = Convert.ToInt32(jdv["TerminalId"]);

                if (jdv["FromDate"] != "")
                {
                    pobj.FromDate = Convert.ToDateTime(jdv["FromDate"]);
                }
                if (jdv["ToDate"] != "")
                {
                    pobj.ToDate = Convert.ToDateTime(jdv["ToDate"]);
                }
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_TerminalReport.BindTerminalList(pobj);
                if (pobj.isException != true)
                {
                    return pobj.Ds.GetXml();
                    //return "true";
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