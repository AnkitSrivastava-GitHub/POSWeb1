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

public partial class Pages_DirectInvoiceGenerate : System.Web.UI.Page
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
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/DirectInvoiceGenerate.js"));
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
    public static string GenDirectInvoice(string dataValues, string InvoiceItemTableValues)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {
            DataTable InvoiceItemdt = new DataTable();
            InvoiceItemdt = JsonConvert.DeserializeObject<DataTable>(InvoiceItemTableValues);
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            PL_GenerateInvoice pobj = new PL_GenerateInvoice();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    if (InvoiceItemdt.Rows.Count > 0)
                    {
                        pobj.DT_InvoiceItem = InvoiceItemdt;
                    }
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                    pobj.PurchageDate = Convert.ToDateTime(jdv["PurchaseDate"]);
                    pobj.VendorAutoId = Convert.ToInt32(jdv["VendorAutoId"]);
                    pobj.PoNumber = "Direct Invoice";
                    pobj.InvoiceNo = jdv["InvoiceNo"];
                    pobj.BatchNo = Convert.ToString(jdv["BatchNo"]);
                    pobj.Remark = jdv["Remark"];
                    BAL_GenerateInvoice.DirectInvoiceGenerate(pobj);
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
    [WebMethod(EnableSession = true)]
    public static string UpdateDirectInvoice(string dataValues, string InvoiceItemTableValues)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {
            DataTable InvoiceItemdt = new DataTable();
            InvoiceItemdt = JsonConvert.DeserializeObject<DataTable>(InvoiceItemTableValues);
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            PL_GenerateInvoice pobj = new PL_GenerateInvoice();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    if (InvoiceItemdt.Rows.Count > 0)
                    {
                        pobj.DT_InvoiceItem = InvoiceItemdt;
                    }
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                    pobj.PurchageDate = Convert.ToDateTime(jdv["PurchaseDate"]);
                    pobj.VendorAutoId = Convert.ToInt32(jdv["VendorAutoId"]);
                    pobj.InvoiceId = Convert.ToInt32(jdv["InvoiceAutoId"]);
                    pobj.PoNumber = "Direct Invoice";
                    pobj.InvoiceNo = jdv["InvoiceNo"];
                    pobj.Remark = jdv["Remark"];
                    BAL_GenerateInvoice.UpdateInvoice(pobj);
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
    [WebMethod(EnableSession = true)]
    public static string editInvoiceDetail(int InvoiceAutoId)
    {
        PL_GenerateInvoice pobj = new PL_GenerateInvoice();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.InvoiceId = Convert.ToInt32(InvoiceAutoId);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_GenerateInvoice.editInvoiceDetail(pobj);
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