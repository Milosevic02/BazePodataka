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
    public class SceneUIHandler
    {
        private static SceneService sceneService = new SceneService();
        public void HandleMenu()
        {
            string answer;
            do
            {
                Console.WriteLine();
                Console.WriteLine("Odaberite funkcionalnost:");
                Console.WriteLine("1  - Prikaz svih po Theatre id");
                Console.WriteLine("X  - Povratak u prethodni meni");

                answer = Console.ReadLine();

                switch (answer)
                {
                    case "1":
                        ShowAllByTheatreId();
                        break;
                   
                }

            } while (!answer.ToUpper().Equals("X"));
        }

        private void ShowAllByTheatreId()
        {
            Console.WriteLine("IDTHE: ");
            int id = int.Parse(Console.ReadLine());

            try
            {
                List<Scene> scenes = sceneService.FindSceneByTheatre(id);

                foreach (Scene scene in scenes)
                {
                    Console.WriteLine(Scene.GetFormattedHeader());
                    Console.WriteLine(scene);
                }

                
            }
            catch (DbException ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        

    }
}
