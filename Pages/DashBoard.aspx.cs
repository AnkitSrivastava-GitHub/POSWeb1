using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Home : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if(Session["EmpAutoId"]==null)
            {
                Session.Abandon();
                Response.Redirect("~/Default.aspx", false);
            }
            else if(Session["EmpType"]==null)
            {
                Session.Abandon();
                Response.Redirect("~/Default.aspx", false);
            }
            else if (Session["EmpType"].ToString() == "Cashier")
            {
                btnCashier.Visible = true;
            }
            else
            {
                btnCashier.Visible = false;
            }
        }
    }
}