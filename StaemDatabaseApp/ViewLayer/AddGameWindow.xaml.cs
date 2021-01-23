﻿using StaemDatabaseApp.DBLayer;
using StaemDatabaseApp.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace StaemDatabaseApp.ViewLayer
{
    /// <summary>
    /// Interaction logic for AddGameWindow.xaml
    /// </summary>
    public partial class AddGameWindow : Window
    {
        public AddGameWindow()
        {
            InitializeComponent();

            //  Setting up status and developer comboBox
            statusComboBox.ItemsSource = StatusDA.RetrieveAllStatuses();
            statusComboBox.SelectedIndex = 0;

            developerComboBox.ItemsSource = DevelopersDA.RetriveAllDevelopers();
            developerComboBox.SelectedIndex = 0;
        }

        private void addButton_Click(object sender, RoutedEventArgs e)
        {
            // Verify game data
            if (nameTextBox.Text.Length == 0)
            {
                MessageBox.Show("Game name cannot be empty", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }
            if (priceTextBox.Text.Length == 0)
            {
                MessageBox.Show("Game price cannot be empty", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            // Game data is correct

            //Retrieve status and developer ID
            Status status = (Status)statusComboBox.SelectedItem;
            string statusID = status.Id.ToString();
            Developer developer = (Developer)developerComboBox.SelectedItem;
            string developerID = developer.Id.ToString();


            bool answer = GamesDA.AddGame(nameTextBox.Text, descriptionTextBox.Text, quantityTextBox.Text, priceTextBox.Text, statusID, developerID);
            if (answer)
            {
                MessageBox.Show("Game was added successfully.", "Success", MessageBoxButton.OK, MessageBoxImage.Information);
                Close();
            }
            else
            {
                MessageBox.Show("An error occuried during this action.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
