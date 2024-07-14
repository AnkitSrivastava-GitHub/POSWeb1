using System.Web.UI.WebControls;
using System.IO;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Web;
using System;

public partial class Pages_InvoicePrintDetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //if (!IsPostBack)
        //{
        if (Session["EmpAutoId"] == null)
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx", false);
        }
        //else if (HttpContext.Current.Session["EmpType"].ToString() != "Admin")
        //{
        //    Session.Abandon();
        //    Response.Redirect("~/Default.aspx", false);
        //}
        else
        {
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/InvoicePrintDetails.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
        //}

    }

    [WebMethod(EnableSession = true)]
    public static string EditInvoicePrintDetails()
    {
        global::DLLInvoicePrintDetails.PL_InvoicePrintDetails pobj = new global::DLLInvoicePrintDetails.PL_InvoicePrintDetails();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                DLLInvoicePrintDetails.BAL_InvoicePrintDetails.EditInvoicePrintDetails(pobj);
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
            return "false";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateInvoicePrintDetails(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        global::DLLInvoicePrintDetails.PL_InvoicePrintDetails pobj = new global::DLLInvoicePrintDetails.PL_InvoicePrintDetails();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.AutoId = Convert.ToInt32(jdv["AutoId"]);
                pobj.StoreName = jdv["StoreName"];
                pobj.Billingaddress = jdv["BillingAddress"];
                pobj.ContactPerson = jdv["ContactPerson"];
                pobj.country = jdv["Country"];
                pobj.mobileNo = jdv["MobileNo"];
                pobj.Website = jdv["Website"];
                pobj.state = jdv["State"];
                pobj.City = jdv["City"];
                pobj.ZipCode = jdv["ZipCode"];
                pobj.EmailId = jdv["EmailId"];
                pobj.CLogo = jdv["CLogo"];
                pobj.ShowHappyPoints = Convert.ToInt32(jdv["ShowHappyPoints"]);
                pobj.ShowFooter = Convert.ToInt32(jdv["ShowFooter"]);
                pobj.ShowLogo = Convert.ToInt32(jdv["ShowLogo"]);
                pobj.Footer = jdv["Footer"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                DLLInvoicePrintDetails.BAL_InvoicePrintDetails.UpdateInvoicePrintDetails(pobj);
                if (!pobj.isException)
                {
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