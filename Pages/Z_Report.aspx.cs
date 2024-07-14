using System;
using DLLZReport;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DLLOrderMaster;
using System.Data;
using System.Web.Services;

public partial class Pages_Z_Report : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
        {
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/Z_Report.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
        else
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx", false);
        }
    }
    [WebMethod(EnableSession = true)]
    public static string Print_ZReport(int AutoId,int ShiftId, string ZReportDate)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {
            PL_ZReport pobj = new PL_ZReport();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.TerminalId = Convert.ToInt32(AutoId);
                    pobj.ShiftId = Convert.ToInt32(ShiftId);
                    if (ZReportDate != "" && ZReportDate != null)
                    {
                        pobj.ZReportDate = Convert.ToDateTime(ZReportDate);
                    }
                    BAL_ZReport.Print_ZReport(pobj);
                    if (!pobj.isException)
                    {
                        string str = "";
                        foreach (DataRow dr in pobj.Ds.Tables[0].Rows)
                        {
                            str += dr[0];
                        }
                        return str;
                    }
                    else
                    {
                        return pobj.exceptionMessage;
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
                return pobj.exceptionMessage;
            }
        }
        else
        {
            return "Session";
        }
    }
    [WebMethod(EnableSession = true)]
    public static string BindTerminalList()
    {
        PL_ZReport pobj = new PL_ZReport();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_ZReport.BindTerminalList(pobj);
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