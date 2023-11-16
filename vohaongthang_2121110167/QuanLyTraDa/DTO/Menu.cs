using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyTraDa.DTO
{
    public class Menu
    {
        public Menu(string foodName, int count, float price, float totalPrice = 0) 
        { 
            this.FoodName = foodName;
            this.Count = count;
            this.Price = price;
            this.TotalPrice = totalPrice;
        }

        public Menu(DataRow row)
        {
            this.FoodName = (string)row["Name"];
            this.Count = (int)row["count"];
            this.Price = (float)Convert.ToDouble(row["price"]);
            this.TotalPrice = (float)Convert.ToDouble(row["totalPrice"]);
        }

        private string foodname;
        private int count;
        private float price;
        private float totalPrice;
        public string FoodName { get => foodname; set => foodname = value; }
        public int Count { get => count; set => count = value; }
        public float Price { get => price; set => price = value; }
        public float TotalPrice { get => totalPrice; set => totalPrice = value; }
    }
}
