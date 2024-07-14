using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using DLLProductGroup;
using Newtonsoft.Json;

public partial class Pages_ProductGroup : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
        {
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/ProductGroup.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
        else
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx", false);
        }
    }
    [WebMethod]
    public static string BindDropdowns()
    {
        PL_ProductGroup pobj = new PL_ProductGroup();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_ProductGroup.BindDropDown(pobj);
                if (pobj.isException != true)
                {
                    string json = "";
                    foreach (DataRow dr in pobj.Ds.Tables[0].Rows)
                    {
                        json += dr[0].ToString();
                    }
                    if (json == "")
                    {
                        json = "[]";
                    }
                    return json;
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
    public static string CreateMixMatchTable(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_ProductGroup pobj = new PL_ProductGroup();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.DepartmentId = Convert.ToInt32(jdv["DepartmentId"]);
                pobj.CategoryId = Convert.ToInt32(jdv["CategoryId"]);
                pobj.SKUId = Convert.ToInt32(jdv["SKUId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_ProductGroup.CreateMixMatchTable(pobj);
                if (pobj.isException != true)
                {
                    string json = "";
                    foreach (DataRow dr in pobj.Ds.Tables[0].Rows)
                    {
                        json += dr[0].ToString();
                    }
                    if (json == "")
                    {
                        json = "[]";
                    }
                    return json;
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
    public static string InsertProductGroup(string dataValues, string ProductGroupTableValues)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {
            DataTable ProductGroupdt = new DataTable();

            ProductGroupdt = JsonConvert.DeserializeObject<DataTable>(ProductGroupTableValues);
           
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            PL_ProductGroup pobj = new PL_ProductGroup();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    if (ProductGroupdt.Rows.Count > 0)
                    {
                        pobj.ProductGroupTable = ProductGroupdt;
                    }
                    
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.GroupName = jdv["GroupName"];
                    pobj.Status = Convert.ToInt32(jdv["Status"]);
                    pobj.Quantity = Convert.ToInt32(jdv["Quantity"]);
                    pobj.DiscountCriteria = Convert.ToInt32(jdv["DiscountCriteria"]);
                    pobj.DiscountValue = Convert.ToDecimal(jdv["DiscountValue"]);
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                
                    BAL_ProductGroup.InsertProductGroup(pobj);
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
    public static string UpdateProductGroup(string dataValues, string ProductGroupTableValues)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {
            DataTable ProductGroupdt = new DataTable();

            ProductGroupdt = JsonConvert.DeserializeObject<DataTable>(ProductGroupTableValues);
           
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            PL_ProductGroup pobj = new PL_ProductGroup();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    if (ProductGroupdt.Rows.Count > 0)
                    {
                        pobj.ProductGroupTable = ProductGroupdt;
                    }
                    
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.GroupId = Convert.ToInt32(jdv["GroupId"]);
                    pobj.GroupName = jdv["GroupName"];
                    pobj.Status = Convert.ToInt32(jdv["Status"]);
                    pobj.Quantity = Convert.ToInt32(jdv["Quantity"]);
                    pobj.DiscountCriteria = Convert.ToInt32(jdv["DiscountCriteria"]);
                    pobj.DiscountValue = Convert.ToDecimal(jdv["DiscountValue"]);
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                    BAL_ProductGroup.UpdateProductGroup(pobj);
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
    public static string editGroupDetail(int GroupAutoId)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {
            PL_ProductGroup pobj = new PL_ProductGroup();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.GroupId = Convert.ToInt32(GroupAutoId);
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                    BAL_ProductGroup.editGroupDetail(pobj);
                    if (!pobj.isException)
                    {
                        string json = "";
                        foreach (DataRow dr in pobj.Ds.Tables[0].Rows)
                        {
                            json += dr[0].ToString();
                        }
                        if (json == "")
                        {
                            json = "[]";
                        }
                        return json;
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