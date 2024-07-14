using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using UserMaster;

public partial class Pages_MyAccount : System.Web.UI.Page
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
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/MyAccount.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
    }
    [WebMethod]
    public static string MyAccount(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_UserMaster pobj = new PL_UserMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.UserAutoId = Convert.ToInt32(jdv["UserAutoId"]);
                pobj.loginId = jdv["LoginId"];
                pobj.FirstName = jdv["FirstName"];
                pobj.LastName = jdv["LastName"];
                pobj.EmailId = jdv["EmailId"];
                pobj.PhoneNo = jdv["PhoneNo"];
                pobj.Password = jdv["Password"];
                pobj.UserType = jdv["UserType"];
                pobj.Status = jdv["Status"];
                pobj.Security = jdv["security"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_UserMaster.MyAccount(pobj);

                if (pobj.isException != true)
                {
                    return pobj.Ds.GetXml();
                    //return "true";
                }
                else
                {
                    return pobj.exceptionMessage.ToString();
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
            return pobj.exceptionMessage = ex.Message;
        }
    }
}