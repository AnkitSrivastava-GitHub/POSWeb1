using DLLChangeStore;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_ChangeStore : System.Web.UI.Page
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
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/ChangeStore.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
    }
    [WebMethod]
    public static string BindStoreList()
    {
        PL_ChangeStore pobj = new PL_ChangeStore();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.EmployeeId = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_ChangeStore.BindStoreList(pobj);
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
    [WebMethod]
    public static string ChangeStore(int CompanyId)
    {
        PL_ChangeStore pobj = new PL_ChangeStore();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CompanyId = CompanyId;
                pobj.EmployeeId = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.LogInAutoId = Convert.ToInt32(HttpContext.Current.Session["LogInAutoId"]);
                BAL_ChangeStore.ChangeStore(pobj);
                if (pobj.isException != true)
                {
                    if (pobj.Ds.Tables[0].Rows.Count > 0)
                    {
                        string CurrencySymbol = pobj.Ds.Tables[0].Rows[0]["CurrencySymbol"].ToString();
                        string StoreId = pobj.Ds.Tables[0].Rows[0]["StoreId"].ToString();
                        string CompanyName = pobj.Ds.Tables[0].Rows[0]["CompanyName"].ToString();
                        HttpContext.Current.Session.Add("StoreId", StoreId);
                        HttpContext.Current.Session.Add("CompanyName", CompanyName);
                        HttpContext.Current.Session.Add("CurrencySymbol", CurrencySymbol);
                        return "true";
                    }
                    else
                    {
                        return "Session";
                    }
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