# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Backend.Repo.insert!(%Backend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Backend.Repo
alias Backend.Parking.Zone
alias Backend.Parking.Street
alias Backend.Parking.ParkingHouse
alias Backend.Accounts.User

# Streets
streets_zone_a = [
  %Street{description: "Gildi tn (lõigul Ülikooli tn – Kompanii tn)", coords: [[26.720381, 58.381612], [26.72133, 58.381663], [26.722312, 58.38175], [26.723063, 58.381812]], total_spaces: 10},
  %Street{description: "Jaani tn", coords: [[26.72007, 58.381958], [26.719839, 58.382228], [26.719625, 58.382467], [26.719533, 58.382541], [26.719426, 58.3826], [26.719335, 58.382667], [26.718756, 58.383066], [26.718536, 58.383269]], total_spaces: 10},
  %Street{description: "Jakobi tn (lõigul Ülikooli tn – K. E. von Baeri tn)", coords: [[26.720515, 58.380818], [26.720209, 58.380742], [26.719367, 58.380629], [26.719158, 58.380621], [26.7189, 58.380795], [26.718579, 58.381059], [26.718187, 58.38136], [26.717799, 58.381595], [26.717381, 58.381809], [26.716491, 58.38211], [26.715439, 58.382284], [26.714511, 58.382453]], total_spaces: 10},
  %Street{description: "K. E. von Baeri tn", coords: [[26.714464, 58.38243], [26.714217, 58.382132], [26.714088, 58.382054], [26.712935, 58.381635], [26.712699, 58.381509], [26.712576, 58.381413], [26.712538, 58.381357], [26.712592, 58.381076], [26.712694, 58.380837], [26.712833, 58.380534], [26.712908, 58.380275], [26.712913, 58.38014], [26.712849, 58.37989], [26.71276, 58.379741], [26.712652, 58.379645], [26.712443, 58.379175], [26.712438, 58.379057], [26.712465, 58.378998], [26.71254, 58.378961], [26.712668, 58.378925], [26.712824, 58.378894], [26.713918, 58.378798], [26.715056, 58.378711], [26.715644, 58.378684], [26.715682, 58.378676], [26.716283, 58.378327], [26.716508, 58.378189], [26.716588, 58.378125]], total_spaces: 10},
  %Street{description: "Kompanii tn", coords: [[26.722755, 58.382365], [26.723064, 58.381812], [26.723233, 58.381503], [26.72337, 58.381327], [26.724231, 58.380594]], total_spaces: 10},
  %Street{description: "Küütri tn (lõigul Rüütli tn – Kompanii tn)", coords: [[26.721964, 58.381078], [26.723348, 58.381328]], total_spaces: 10},
  %Street{description: "Lai tn (lõigul Rüütli tn – Jakobi tn)", coords: [[26.716501, 58.382114], [26.717741, 58.382966], [26.71806, 58.383134], [26.71847, 58.38326], [26.719468, 58.383479], [26.720391, 58.38364]], total_spaces: 10},
  %Street{description: "Lossi tn", coords: [[26.720931, 58.380201], [26.720747, 58.380183], [26.719248, 58.379899], [26.718372, 58.379724], [26.718061, 58.379664], [26.717676, 58.379596], [26.717266, 58.379506], [26.716696, 58.379392], [26.716463, 58.379362], [26.716409, 58.379346], [26.716291, 58.379261], [26.715906, 58.378944], [26.715643, 58.378691]], total_spaces: 10},
  %Street{description: "Lutsu tn", coords: [[26.717387, 58.381809], [26.718741, 58.382422], [26.719348, 58.382661], [26.720474, 58.382876], [26.720825, 58.382911]], total_spaces: 10},
  %Street{description: "Magasini tn", coords: [[26.721289, 58.383795], [26.721527, 58.383481], [26.721549, 58.383376], [26.721587, 58.382981], [26.721662, 58.382478], [26.721727, 58.382208]], total_spaces: 10},
  %Street{description: "Munga tn", coords: [[26.723975, 58.382546], [26.723433, 58.382464], [26.721765, 58.382215], [26.720411, 58.382037], [26.720067, 58.381955], [26.718919, 58.381618], [26.718501, 58.381457], [26.7182, 58.381359]], total_spaces: 10},
  %Street{description: "Poe tn", coords: [[26.725491, 58.380013], [26.725367, 58.379972], [26.724614, 58.379644], [26.723935, 58.379466], [26.723814, 58.379418]], total_spaces: 10},
  %Street{description: "Promenaadi tn", coords: [[26.723725, 58.378655], [26.724232, 58.378228]], total_spaces: 10},
  %Street{description: "Uueturu tn", coords: [[26.727512, 58.378695], [26.72734, 58.378599], [26.726605, 58.378255], [26.726265, 58.378051], [26.726267, 58.378003], [26.726332, 58.377991], [26.726729, 58.378183], [26.727659, 58.378609]], total_spaces: 10},
  %Street{description: "Vabaduse pst (lõigul Lai tn – Uueturu tn)", coords: [[26.727012, 58.379065], [26.726713, 58.379269], [26.725954, 58.379702], [26.725557, 58.379977], [26.725055, 58.380518], [26.724782, 58.381054], [26.723988, 58.38253], [26.72363, 58.383262], [26.7233, 58.384021]], total_spaces: 10},
  %Street{description: "Vallikraavi tn (lõigul Küüni tn – Lossi tn)", coords: [[26.724136, 58.378876], [26.723898, 58.378738], [26.723691, 58.37864], [26.723219, 58.378454], [26.723029, 58.378339], [26.722726, 58.378111], [26.722535, 58.377959], [26.722492, 58.377937], [26.722398, 58.377918], [26.722291, 58.377913], [26.722061, 58.37792], [26.72059, 58.378084], [26.720261, 58.378093], [26.719862, 58.378072], [26.719717, 58.378065], [26.718931, 58.377968], [26.717689, 58.377665], [26.717526, 58.377633], [26.717406, 58.377628], [26.717297, 58.377643], [26.717205, 58.377694], [26.71668, 58.37805], [26.716592, 58.378123]], total_spaces: 10},
  %Street{description: "Ülikooli tn", coords: [[26.726122, 58.376642], [26.725891, 58.376777], [26.724952, 58.377382], [26.724045, 58.377927], [26.723203, 58.37846], [26.72246, 58.379129], [26.721891, 58.379614], [26.721438, 58.379965], [26.721254, 58.380081], [26.720937, 58.380203], [26.720942, 58.380316], [26.720873, 58.380458], [26.720527, 58.380823], [26.720479, 58.380892], [26.720452, 58.380986], [26.720369, 58.381612], [26.720088, 58.381952]], total_spaces: 10}
]

streets_zone_b = [
  %Street{description: "A. Haava tn (lõigul Näituse tn – J. Tõnissoni tn)", coords: [[26.704763, 58.378274], [26.705187, 58.377678], [26.705562, 58.377053], [26.706185, 58.376084], [26.706684, 58.375322]], total_spaces: 10},
  %Street{description: "Aida tn", coords: [[26.735573, 58.37397], [26.734591, 58.373635], [26.733663, 58.373362], [26.731737, 58.372704]], total_spaces: 10},
  %Street{description: "Akadeemia tn", coords: [[26.719253, 58.376801], [26.719821, 58.376369], [26.720902, 58.375651], [26.721578, 58.375185], [26.722888, 58.374311], [26.722947, 58.374288]], total_spaces: 10},
  %Street{description: "Aleksandri tn (lõigul Soola tn – Aida tn)", coords: [[26.728828, 58.376238], [26.729869, 58.375653], [26.730276, 58.375399], [26.731312, 58.374805], [26.732157, 58.374272], [26.73246, 58.374098], [26.733672, 58.373373]], total_spaces: 10},
  %Street{description: "J. Kuperjanovi tn (lõigul Vallikraavi tn - Kastani tn)", coords: [[26.715377, 58.376647], [26.714245, 58.376567], [26.713891, 58.376549], [26.713419, 58.376512], [26.712499, 58.376433], [26.711614, 58.376282], [26.71107, 58.376217]], total_spaces: 10},
  %Street{description: "J. Kuperjanovi tn (lõigul Kastani tn - Vaksali tn)", coords: [[26.710844, 58.37617], [26.71074, 58.376144], [26.710582, 58.376066], [26.707956, 58.374511], [26.707332, 58.374181]], total_spaces: 10},
  %Street{description: "J. Liivi tn", coords: [[26.710928, 58.37805], [26.711148, 58.378096], [26.7124, 58.378379], [26.712797, 58.378456], [26.713232, 58.378535], [26.713478, 58.378566], [26.714216, 58.378548], [26.715212, 58.378528], [26.7153, 58.378544], [26.71541, 58.378575], [26.715617, 58.378679]], total_spaces: 10},
  %Street{description: "J. Tõnissoni tn", coords: [[26.71082, 58.376229], [26.710716, 58.376239], [26.710522, 58.376236], [26.70994, 58.376194], [26.70968, 58.376164], [26.709602, 58.376152], [26.708638, 58.375898], [26.70752, 58.375554], [26.706697, 58.375329], [26.705582, 58.375]], total_spaces: 10},
  %Street{description: "J. W. F. Hezeli tn", coords: [[26.713646, 58.378818], [26.712927, 58.378573], [26.71285, 58.378532], [26.712815, 58.3785], [26.712807, 58.378466]], total_spaces: 10},
  %Street{description: "Kalevi tn (lõigul Lille tn – Aida tn)", coords: [[26.728481, 58.37523], [26.729519, 58.37447], [26.729792, 58.37422], [26.730195, 58.373908], [26.730747, 58.373493], [26.731744, 58.372713]], total_spaces: 10},
  %Street{description: "Kaluri tn", coords: [[26.731764, 58.377687], [26.732443, 58.377266], [26.733199, 58.376856]], total_spaces: 10},
  %Street{description: "Kastani tn (lõigul Näituse tn – J. Kuperjanovi tn)", coords: [[26.709053, 58.379052], [26.709337, 58.378505], [26.710056, 58.377469], [26.710437, 58.376933], [26.710933, 58.376276]], total_spaces: 10},
  %Street{description: "Kastani tn (lõigul J. Kuperjanovi tn – Riia tn)", coords: [[26.711009, 58.376152], [26.711082, 58.37597], [26.71157, 58.375164], [26.711853, 58.37478], [26.71219, 58.374275], [26.712539, 58.373794], [26.712907, 58.373292], [26.713256, 58.372815], [26.713727, 58.372215], [26.714194, 58.371557], [26.714546, 58.371067], [26.714769, 58.370875]], total_spaces: 10},
  %Street{description: "Kloostri tn", coords: [[26.716902, 58.384103], [26.717736, 58.383473], [26.718122, 58.383195]], total_spaces: 10},
  %Street{description: "Kooli tn", coords: [[26.706916, 58.378647], [26.706923, 58.378601], [26.707136, 58.378265], [26.70733, 58.377962], [26.708116, 58.376712], [26.708244, 58.376491], [26.708273, 58.376451], [26.708631, 58.375906]], total_spaces: 10},
  %Street{description: "Kooli tn (lõigul Kooli tn. - A. Haava tn.)", coords: [[26.708258, 58.37645], [26.706204, 58.376092]], total_spaces: 10},
  %Street{description: "Kroonuaia tn (lõigul Oa tn – Jakobi tn)", coords: [[26.720378, 58.385568], [26.719971, 58.385331], [26.719547, 58.385113], [26.718903, 58.384784], [26.718785, 58.384709], [26.718232, 58.384403], [26.718168, 58.384378], [26.718029, 58.384346], [26.716881, 58.384125], [26.716071, 58.384003], [26.715961, 58.383969], [26.715896, 58.383942], [26.715832, 58.383899], [26.715636, 58.38372], [26.715287, 58.383325], [26.71493, 58.382917], [26.714683, 58.382635], [26.714533, 58.382476]], total_spaces: 10},
  %Street{description: "Lao tn", coords: [[26.73087, 58.375051], [26.729527, 58.374474]], total_spaces: 10},
  %Street{description: "Lille tn", coords: [[26.728456, 58.375229], [26.72764, 58.375029], [26.726283, 58.374724], [26.725098, 58.374482]], total_spaces: 10},
  %Street{description: "Magistri tn", coords: [[26.72359, 58.381851], [26.723971, 58.381365], [26.724427, 58.380757]], total_spaces: 10},
  %Street{description: "Näituse tn (lõigul Kooli tn – K. E. von Baeri tn)", coords: [[26.706938, 58.378665], [26.707598, 58.378796], [26.708231, 58.378912], [26.708315, 58.378934], [26.709069, 58.379054], [26.70982, 58.379234], [26.710483, 58.379378], [26.710878, 58.379469], [26.711101, 58.379525], [26.71142, 58.379579], [26.711561, 58.379601], [26.711703, 58.379618], [26.711859, 58.379631], [26.712041, 58.379642], [26.712261, 58.379648], [26.712443, 58.379645], [26.712619, 58.379649]], total_spaces: 10},
  %Street{description: "Oru tn (lõigul Veski tn – K. E. von Baeri tn)", coords: [[26.709801, 58.382253], [26.71044, 58.381938], [26.710938, 58.381595], [26.710951, 58.381585], [26.710971, 58.381578], [26.711, 58.38157], [26.71107, 58.38156], [26.711161, 58.381554], [26.711338, 58.381542], [26.711439, 58.381532], [26.711617, 58.381512], [26.712527, 58.381367]], total_spaces: 10},
  %Street{description: "Pargi tn", coords: [[26.732134, 58.372367], [26.731909, 58.372318], [26.731356, 58.372243], [26.729924, 58.372118], [26.729304, 58.372052], [26.728784, 58.371924], [26.72861, 58.371861], [26.728567, 58.371834], [26.728183, 58.37136], [26.727682, 58.371055], [26.727529, 58.370945], [26.72729, 58.370703]], total_spaces: 10},
  %Street{description: "Pepleri tn", coords: [[26.715388, 58.376649], [26.715565, 58.376647], [26.716616, 58.376664], [26.716766, 58.376664], [26.716831, 58.37665], [26.716901, 58.376626], [26.716941, 58.376598], [26.71709, 58.37645], [26.71746, 58.376143], [26.717686, 58.375952], [26.718128, 58.375481], [26.718825, 58.374776], [26.719228, 58.374263], [26.719432, 58.374086], [26.719673, 58.373831], [26.719801, 58.373667], [26.719963, 58.373501], [26.72029, 58.37318]], total_spaces: 10},
  %Street{description: "Päeva tn", coords: [[26.726334, 58.372038], [26.727051, 58.372263], [26.728204, 58.372634], [26.728807, 58.372837], [26.728955, 58.372888]], total_spaces: 10},
  %Street{description: "Riia tn (lõigul Lille tn - Riia tn)", coords: [[26.72509, 58.374482], [26.724264, 58.3747]], total_spaces: 10},
  %Street{description: "Sadama tn (lõigul Turu tn – Kaluri tn)", coords: [[26.73203, 58.3763], [26.732524, 58.376541], [26.733203, 58.376849]], total_spaces: 10},
  %Street{description: "Soola tn (lõigul Väike Turu tn – Turu sild)", coords: [[26.736266, 58.378411], [26.735024, 58.378427], [26.734804, 58.378434], [26.733267, 58.378407]], total_spaces: 10},
  %Street{description: "Tiigi tn", coords: [[26.721108, 58.37744], [26.720837, 58.377379], [26.720437, 58.377237], [26.719788, 58.377], [26.717924, 58.376315], [26.71746, 58.376149], [26.716882, 58.375961], [26.716051, 58.375668], [26.715144, 58.375339], [26.714533, 58.375118], [26.713717, 58.374831], [26.713463, 58.374737], [26.712202, 58.374284], [26.711615, 58.37408], [26.710424, 58.373651], [26.709375, 58.373281], [26.708764, 58.373063]], total_spaces: 10},
  %Street{description: "Tähe tn (lõigul Riia tn – Pargi tn)", coords: [[26.723215, 58.374248], [26.724251, 58.373824], [26.725238, 58.373536], [26.726045, 58.372383], [26.726441, 58.371826], [26.727251, 58.370702]], total_spaces: 10},
  %Street{description: "Tähtvere tn (lõigul Marja tn – Kroonuaia tn)", coords: [[26.714599, 58.382553], [26.712601, 58.383641], [26.712277, 58.383824], [26.712032, 58.383993], [26.711547, 58.384316], [26.711, 58.384653], [26.710357, 58.385013]], total_spaces: 10},
  %Street{description: "Vabriku tn", coords: [[26.705546, 58.377055], [26.702974, 58.37663]], total_spaces: 10},
  %Street{description: "Vaksali tn (lõigul J. Tõnissoni tn – Vanemuise tn)", coords: [[26.705572, 58.374976], [26.706038, 58.374706], [26.70669, 58.374336], [26.706897, 58.374286], [26.706953, 58.374265], [26.707146, 58.374225], [26.707425, 58.37412], [26.707522, 58.373997], [26.707696, 58.373715], [26.708705, 58.373058], [26.710087, 58.372195]], total_spaces: 10},
  %Street{description: "Vallikraavi tn (lõigul Lossi tn – Pepleri tn)", coords: [[26.715378, 58.376658], [26.71533, 58.376872], [26.715264, 58.377306], [26.715187, 58.377578], [26.715189, 58.377646], [26.7152, 58.377713], [26.715232, 58.377749], [26.715286, 58.377784], [26.715348, 58.377812], [26.716045, 58.378003], [26.716559, 58.378115]], total_spaces: 10},
  %Street{description: "Vanemuise tn", coords: [[26.71881, 58.374771], [26.717845, 58.374324], [26.716933, 58.373938], [26.716457, 58.37375], [26.715167, 58.37328], [26.714796, 58.373145], [26.714577, 58.373083], [26.71327, 58.372819], [26.710647, 58.372303], [26.710224, 58.372221], [26.710141, 58.372194]], total_spaces: 10},
  %Street{description: "Veski tn", coords: [[26.711042, 58.382965], [26.709924, 58.382315], [26.70978, 58.382269], [26.709702, 58.382226], [26.7096, 58.382157], [26.709557, 58.382112], [26.709525, 58.382073], [26.709479, 58.381824], [26.709348, 58.380911], [26.709328, 58.380745], [26.70931, 58.379993], [26.709324, 58.379919], [26.709337, 58.379874], [26.709367, 58.379817], [26.709697, 58.379353], [26.709724, 58.379315], [26.709807, 58.379246]], total_spaces: 10},
  %Street{description: "Võru tn (lõigul Väike-Tähe tn – Riia tn)", coords: [[26.722204, 58.37207], [26.722703, 58.372767], [26.722811, 58.372971], [26.722946, 58.373496], [26.722983, 58.373994], [26.72297, 58.374037], [26.722962, 58.374143]], total_spaces: 10},
  %Street{description: "Väike-Tähe tn (lõigul Võru tn – Tähe tn)", coords: [[26.722232, 58.372039], [26.722564, 58.371977], [26.723157, 58.371946], [26.723554, 58.371962], [26.726003, 58.372378]], total_spaces: 10},
  %Street{description: "W. Struve tn", coords: [[26.722431, 58.376302], [26.722873, 58.375907], [26.723249, 58.375559], [26.723606, 58.375162], [26.723793, 58.374993], [26.724005, 58.374858]], total_spaces: 10},
  %Street{description: "Õpetaja tn", coords: [[26.718312, 58.375256], [26.715857, 58.374467], [26.715509, 58.374709], [26.715256, 58.375001], [26.715213, 58.375045], [26.715046, 58.375278]], total_spaces: 10}
]

parking_houses_zone_a = [
  %ParkingHouse{description: "K. E. von Baeri tn 1a parkla", coords: [26.714202, 58.382372], poly_coords: [[26.714443, 58.38243], [26.714135, 58.382491], [26.714081, 58.382282], [26.714258, 58.382254]], total_spaces: 20},
  %ParkingHouse{description: "Vallikraavi tn 4a parkla", coords: [26.722503, 58.377861], poly_coords: [[26.722001, 58.377906], [26.722001, 58.377859], [26.722659, 58.377812], [26.722822, 58.377857], [26.722629, 58.377986], [26.72249, 58.377909], [26.722288, 58.377887]], total_spaces: 20}
]

parking_houses_zone_b = [
  %ParkingHouse{description: "Soola tn 3a parkla (Tartu hotelli ees asuv parkla)", coords: [26.733025, 58.377899], poly_coords: [[26.732527, 58.377846], [26.733208, 58.378161], [26.733583, 58.377986], [26.732929, 58.377649]], total_spaces: 20},
  %ParkingHouse{description: "Soola tn T5 parkla (Turusilla parkla)", coords: [26.735659, 58.378514], poly_coords: [[26.735053, 58.378455], [26.735225, 58.378582], [26.735241, 58.378697], [26.736056, 58.378709], [26.736169, 58.378585], [26.736217, 58.378433]], total_spaces: 20},
  %ParkingHouse{description: "Turu tn 10 parkla (Aura veekeskuse parkla)", coords: [26.735263, 58.375201], poly_coords: [[26.734298, 58.375199], [26.736594, 58.375545], [26.736717, 58.375305], [26.734486, 58.374957]], total_spaces: 20},
  %ParkingHouse{description: "Vanemuise tn 15 parkla (Tartu Ülikooli raamatukogu ees asuv parkla)", coords: [26.722603, 58.376728], poly_coords: [[26.722506, 58.376438], [26.722055, 58.376809], [26.722699, 58.377093], [26.72316, 58.376716]], total_spaces: 20},
  %ParkingHouse{description: "Magistri tn parkla (Tartu Oskar Lutsu nimelise Linnaraamatukogu ees asuv parkla)", coords: [26.724185, 58.381457], poly_coords: [[26.723616, 58.381848], [26.724233, 58.381898], [26.724641, 58.381144], [26.724335, 58.381088], [26.724447, 58.380939], [26.724324, 58.380917]], total_spaces: 20},
  %ParkingHouse{description: "Väike-Turu tn 2 parkla (Sadamaturu parkla)", coords: [26.734506, 58.378], poly_coords: [[26.733433, 58.378152], [26.733975, 58.378225], [26.734162, 58.378183], [26.734313, 58.378261], [26.73435, 58.378396], [26.735804, 58.378394], [26.735804, 58.378349], [26.73516, 58.378337], [26.735149, 58.378177], [26.735203, 58.377913], [26.735106, 58.377887], [26.735096, 58.377696], [26.735316, 58.377595], [26.734935, 58.37742]], total_spaces: 20}
]

# Parking zones
Repo.insert!(%Zone{name: "A", fee_hourly: 2.0, fee_real_time: 0.16, streets: streets_zone_a, parking_houses: parking_houses_zone_a})
Repo.insert!(%Zone{name: "B", fee_hourly: 1.0, fee_real_time: 0.08, streets: streets_zone_b, parking_houses: parking_houses_zone_b})

# Test user
Repo.insert!(%User{email: "test@mail.com", encrypted_password: "password"})