using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.Services;
using System.Web.Script.Serialization;
using CustomerMaster;

public partial class Pages_CustomerMaster : System.Web.UI.Page
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
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/CustomerMaster.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
    }
    [WebMethod]
    public static string BindDropDowns()
    {
        PL_CustomerMaster pobj = new PL_CustomerMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                BAL_CustomerMaster.BindState(pobj);
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
    [WebMethod]
    public static string InsertCustomer(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CustomerMaster pobj = new PL_CustomerMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.FirstName = jdv["FirstName"];
                pobj.LastName = jdv["LastName"];
                pobj.MobileNo = jdv["MobileNo"];
                pobj.Address = jdv["Address"];
                pobj.State = Convert.ToInt32(jdv["State"]);
                pobj.City = jdv["City"];
                pobj.ZipCode = jdv["ZipCode"];
                pobj.EmailId = jdv["EmailId"];
                pobj.DOB = jdv["DOB"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_CustomerMaster.InsertCustomer(pobj);
                if (pobj.isException != true)
                {
                    //return pobj.Ds.GetXml();
                    return "true";
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