using DLLGenerateInvoice;
using DLLPOMaster;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_GenerateInvoice : System.Web.UI.Page
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
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/GenerateInvoice.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
    }

    [WebMethod]
    public static string CurrencySymbol()
    {
        string CurrencySymbol = "";
        if (System.Web.HttpContext.Current.Session["CurrencySymbol"] != null)
        {

            CurrencySymbol = Convert.ToString(HttpContext.Current.Session["CurrencySymbol"]);

            return CurrencySymbol;
        }
        else
        {
            return "Session";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string GetPoDetail(int POAutoId)
    {
        PL_GenerateInvoice pobj = new PL_GenerateInvoice();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.PoAutoId = Convert.ToInt32(POAutoId);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_GenerateInvoice.GetPODetail(pobj);
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
    public static string GenerateInvoice(string dataValues, string PoItemTableValues)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {
            DataTable PoItmedt = new DataTable();
            PoItmedt = JsonConvert.DeserializeObject<DataTable>(PoItemTableValues);
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            PL_GenerateInvoice pobj = new PL_GenerateInvoice();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    if (PoItmedt.Rows.Count > 0)
                    {
                        pobj.DT_InvoiceItem = PoItmedt;
                    }
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                    pobj.PurchageDate = Convert.ToDateTime(jdv["InvoiceDate"]);
                    pobj.PoAutoId = Convert.ToInt32(jdv["POAutoId"]);
                    pobj.PoNumber = jdv["PoNumber"];
                    pobj.BatchNo = Convert.ToString(jdv["BatchNo"]);
                    pobj.InvoiceNo = jdv["InvoiceNo"];
                    BAL_GenerateInvoice.GenerateInvoice(pobj);
                    if (!pobj.isException)
                    {
                        return "true";
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
}