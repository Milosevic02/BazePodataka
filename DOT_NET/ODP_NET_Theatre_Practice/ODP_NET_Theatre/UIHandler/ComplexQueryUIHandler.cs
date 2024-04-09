using ODP_NET_Theatre.DTO.ComplexQuery1;
using ODP_NET_Theatre.DTO.ComplexQuery2;
using ODP_NET_Theatre.DTO.ComplexQuery3;
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
    public class ComplexQueryUIHandler
    {

        private static readonly ComplexFuncionalityService complexQueryService = new ComplexFuncionalityService();

        public void HandleMenu()
        {
            String answer;
            do
            {
                Console.WriteLine("\n1  - Za svako pozoriste prikazati listu scene koje ima. Ukoliko pozoriste nema scenu ispisati: NEMA SCENE");
                Console.WriteLine(
                      "\n2  - Prikazati informacije o predstavama koje se prikazuju. Pored osnovnih informacija o predstavama prikazati sva prikazivanja"
                          + "\n     za svaku od njih. Za svaku predstavu prikazati ukupan broj gledalaca, prosecan broj gledalaca i broj prikazivanja.");
                Console.WriteLine(
                        "\n3  - Prikazati id, nazive i prosecan broj gledalaca predstava koje imaju najveci prosecan broj gledalaca. Za te predstave prikazati listu uloga."
                                + "\n     Pored toga prikazati koliko ukupno ima muskih uloga i koliko ukupno ima zenskih uloga..");
                


                Console.WriteLine("\nX  - Izlazak iz kompleksnih upita");

                answer = Console.ReadLine();

                switch (answer)
                {
                    case "1":
                        ShowSceneForTheatre();
                        break;
                    case "2":
                        ShowReportingForShowingShows();
                        break;
                    case "3":
                        ShowMostVisitedShow();
                        break;
                }

            } while (!answer.ToUpper().Equals("X"));
        }

        private void ShowSceneForTheatre() 
        {
            try
            {
                List<ScenesForTheatreDTO> dtos = complexQueryService.GetScenesForTheatres();
                if(dtos.Count != 0)
                {
                    foreach(ScenesForTheatreDTO dto in dtos)
                    {
                        Console.WriteLine(dto.Theatre);
                        Console.WriteLine("\t\t------------------------------- SCENE -------------------------------");

                        if(dto.Scenes.Count != 0)
                        {
                            Console.WriteLine("\t\t" + Scene.GetFormattedHeader());
                            foreach(Scene scene in dto.Scenes)
                            {
                                Console.WriteLine("\t\t" + scene);
                            }
                        }
                        else
                        {
                            Console.WriteLine("\t\tNEMA SCENE");

                        }
                        Console.WriteLine("\t\t---------------------------------------------------------------------");
                        Console.WriteLine();
                    }
                }
                else
                {
                    Console.WriteLine("\t\tNEMA POZORISTA.");
                }
            }catch(DbException ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        public void ShowReportingForShowingShows()
        {
            try
            {
                foreach(ShowingsForPlayDTO dto in complexQueryService.GetShowingsForPlayDTO())
                {
                    String statsHeader = String.Format("{0,-30} {1,-30:F2} {2,-30}", "UKUPAN BROJ GLEDALACA", "PROSECAN BROJ GLEDALACA", "BROJ PRIKAZIVANJA");
                    Console.WriteLine(Play.GetFormattedHeader() + " " + statsHeader);
                    Console.WriteLine(dto.Play + " " + dto.Stats);

                    Console.WriteLine("\t\t---------------------------PRIKAZIVANJA----------------------------------");
                    Console.WriteLine("\t\t" + Showing.GetFormattedHeader());
                    foreach (Showing showing in dto.Showings)
                    {
                        Console.WriteLine("\t\t" + showing);
                    }
                    Console.WriteLine("\t\t-------------------------------------------------------------------------");
                    Console.WriteLine("\n\n");
                }

            }
            catch (DbException ex)
            {
                Console.WriteLine(ex.Message);
            }

        }

        public void ShowMostVisitedShow()
        {
            try
            {
                foreach (PlayDTO p in complexQueryService.GetMostVisitedPlays())
                {
                    Console.WriteLine(PlayDTO.GetFormatedHeader());
                    Console.WriteLine(p);
                    Console.WriteLine("\t\t--------------------ULOGE------------------------");
                    Console.WriteLine("\t\t" + Role.GetFormattedHeader());
                    foreach (Role role in p.Roles)
                    {
                        Console.WriteLine("\t\t" + role);
                    }
                    Console.WriteLine("\t\t-----------UKUPAN BROJ ZENSKIH ULOGA-------------");
                    Console.WriteLine("\t\t" + p.FemaleRolesTotal);
                    Console.WriteLine("\t\t-----------UKUPAN BROJ MUSKIH ULOGA--------------");
                    Console.WriteLine("\t\t" + p.MaleRolesTotal);
                }
            }
            catch (DbException ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

    }
}
