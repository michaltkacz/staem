﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StaemDatabaseApp.Model
{
    class Game
    {
        public Game(string id, string name, string description, string quantity, string price, Status status, Developer developer)
        {
            //Id = id;
            //Name = name;
            //Description = description;
            //Quantity = quantity;
            //Price = price;
            //Status = status;
            //Developer = developer;
        }

        public Game(int id, string name, string description, int quantity, float price, Status status, Developer developer)
        {
            Id = id;
            Name = name;
            Description = description;
            Quantity = quantity;
            Price = price;
            Status = status;
            Developer = developer;
        }

        private int id;
        private string name;
        private string description;
        private int quantity;
        private float price;
        private Status status;
        private Developer developer;

        public int Id { get => id; set => id = value; }
        public string Name { get => name; set => name = value; }
        public string Description { get => description; set => description = value; }
        public int Quantity { get => quantity; set => quantity = value; }
        public float Price { get => price; set => price = value; }
        internal Status Status { get => status; set => status = value; }
        internal Developer Developer { get => developer; set => developer = value; }
    }
}
