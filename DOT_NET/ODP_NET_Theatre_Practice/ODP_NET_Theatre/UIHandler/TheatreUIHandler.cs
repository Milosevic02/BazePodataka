using ODP_NET_Theatre.Model;
using ODP_NET_Theatre.Service;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ODP_NET_Theatre.UIHandler
{
    public class TheatreUIHandler
    {
        private static readonly TheatreService theatreService = new TheatreService();

        public void HandleMenu()
        {
            string answer;
            do
            {
                Console.WriteLine();
                Console.WriteLine("Odaberite funkcionalnost:");
                Console.WriteLine("1  - Prikaz svih");
                Console.WriteLine("2  - Prikaz po identifikatoru");
                Console.WriteLine("3  - Unos jednog");
                Console.WriteLine("4  - Izmena po identifikatoru");
                Console.WriteLine("5  - Brisanje po identifikatoru");
                Console.WriteLine("X  - Povratak u prethodni meni");

                answer = Console.ReadLine();

                switch (answer)
                {
                    case "1":
                        ShowAll();
                        break;
                    case "2":
                        ShowById();
                        break;
                    case "3":
                        HandleSingleInsert();
                        break;
                    case "4":
                        HandleUpdate();
                        break;
                    case "5":
                        HandleDelete();
                        break;
                }

            } while (!answer.ToUpper().Equals("X"));
        }

        private void ShowAll()
        {

        }

        private void ShowById()
        {
            Console.WriteLine("IDPOZ: ");
            int id = int.Parse(Console.ReadLine());

            try
            {
                Theatre theatre = theatreService.FindById(id);

                Console.WriteLine(Theatre.GetFormattedHeader());
                Console.WriteLine(theatre);
            }
            catch (DbException ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        private void HandleSingleInsert()
        {
            Console.WriteLine("IDPOZ: ");
            int id = int.Parse(Console.ReadLine());

            Console.WriteLine("Naziv: ");
            string nameTh = Console.ReadLine();

            Console.WriteLine("Adresa: ");
            string addressTh = Console.ReadLine();

            Console.WriteLine("Sajt: ");
            string webisteTh = Console.ReadLine();

            Console.WriteLine("Mesto: ");
            int placeIdPl = int.Parse(Console.ReadLine());

            try
            {
                int inserted = theatreService.Save(new Theatre(id, nameTh, addressTh, webisteTh, placeIdPl));
                if (inserted != 0)
                {
                    Console.WriteLine("Pozoriste \"{0}\" uspešno uneto.", nameTh);
                }
            }
            catch (DbException ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        private void HandleUpdate()
        {
            Console.WriteLine("IDPOZ: ");
            int id = int.Parse(Console.ReadLine());

            try
            {
                if (!theatreService.ExistsById(id))
                {
                    Console.WriteLine("Uneta vrednost ne postoji!");
                    return;
                }

                Console.WriteLine("Naziv: ");
                string nameTh = Console.ReadLine();

                Console.WriteLine("Adresa: ");
                string addressTh = Console.ReadLine();

                Console.WriteLine("Sajt: ");
                string webisteTh = Console.ReadLine();

                Console.WriteLine("Mesto: ");
                int placeIdPl = int.Parse(Console.ReadLine());

                int updated = theatreService.Save(new Theatre(id, nameTh, addressTh, webisteTh, placeIdPl));
                if (updated != 0)
                {
                    Console.WriteLine("Pozoriste \"{0}\" uspešno izmenjeno.", id);
                }
            }
            catch (DbException ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        private void HandleDelete()
        {
            Console.WriteLine("IDPOZ: ");
            int id = int.Parse(Console.ReadLine());

            try
            {
                int deleted = theatreService.DeleteById(id);
                if (deleted != 0)
                {
                    Console.WriteLine("Pozoriste sa šifrom \"{0}\" uspešno obrisano.", id);
                }
            }
            catch (DbException ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

    }
}
