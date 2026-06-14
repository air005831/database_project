-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 2026-06-14 03:10:55
-- 伺服器版本： 10.4.32-MariaDB
-- PHP 版本： 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `nojo_django_db`
--

-- --------------------------------------------------------

--
-- 資料表結構 `authtoken_token`
--

CREATE TABLE `authtoken_token` (
  `key` varchar(40) NOT NULL,
  `created` datetime(6) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- 傾印資料表的資料 `authtoken_token`
--

INSERT INTO `authtoken_token` (`key`, `created`, `user_id`) VALUES
('00c115c89bc65cc97e41cc289b02452e1242a98c', '2026-06-08 20:06:52.394334', 281),
('01cf616b7ca70ca6fa86eb99ca6612614f8a9d87', '2026-06-08 18:55:45.124669', 52),
('05c6f6cd75a12f2ab5c2f360f664dc74f653f64b', '2026-06-08 20:06:45.403872', 278),
('06775a562f6f84fb8684f418c515e1ae92d5ae2e', '2026-06-08 16:32:04.206448', 237),
('073bb3716de6c4cdbda4ebb27b80137a11647dd2', '2026-06-08 16:09:23.362737', 226),
('0beb9eafea817b57ba89d8348fc2e7156a3b6649', '2026-06-09 03:00:25.197972', 326),
('0d5e31fcce537c0cb2b557c544a221092cabe706', '2026-06-08 17:11:12.617613', 251),
('10f689589cebdd529fd0f1aefa2906eb6009c5ad', '2026-06-10 06:10:07.771452', 364),
('11877ee79d40c9f5fbe5c97ff97a6b866b71ccca', '2026-06-08 20:45:57.482549', 294),
('12be31dd3679d6eebea05a8809f06b63e68b822c', '2026-06-08 18:16:42.269425', 258),
('12c4cca71e56f4e70c8d4cdac6867982fddba6a5', '2026-06-11 05:07:12.858394', 391),
('1363562031dbd4a6ff6d38d0b11456e008213495', '2026-06-08 14:17:47.553403', 193),
('169958c452fa1742da0a3346351bf433fdd004c6', '2026-06-08 14:38:39.706662', 204),
('176de9dd6f4ebb729da09ccd216c9db676f91c46', '2026-06-08 20:58:15.490087', 305),
('17a6e7de5a8351263f416e5a108bc6d1d2560863', '2026-06-08 19:17:50.060956', 269),
('19cbb0745a24859e2cc8b398ce2a287551800f7f', '2026-06-11 04:54:04.841914', 369),
('19e7d0f68d94c80f7c2cb9fc836f80138f6e6040', '2026-06-11 04:55:45.376064', 375),
('1bf10d6ee0e8e86b762b0e485ca634421ac1c208', '2026-06-09 08:44:57.656324', 353),
('1e3d6559053ab916e2965c0c363c0b7120de851e', '2026-06-08 20:44:56.377764', 291),
('1e75bfee87a4cc00cff882f3869568a0accf099b', '2026-06-08 20:06:12.608241', 271),
('1ee3857b91e048b6e82e0258759cd8fb63b16231', '2026-06-09 03:56:03.558888', 337),
('1ee662f6f4ac6ec27c187c3776c72c73e1b4c1fc', '2026-06-08 16:09:22.546413', 224),
('240d9969761b49a2d3481ba7cf021fa322a2b68d', '2026-06-09 03:00:25.970575', 327),
('249dcd522a0feef27c6481abecc618a24fd5e1da', '2026-06-11 05:17:45.254870', 411),
('24a84bb1dfeb8fec6976eab68f1081ce291111d6', '2026-06-08 14:21:41.187678', 49),
('26c5f4f1185f52922489d0e11bb0e8741304902a', '2026-06-08 21:14:58.500678', 308),
('26d89e366327d6458815547d95937b9d1f3a0a3d', '2026-06-11 05:15:05.820168', 396),
('2726cc049a177e4d4875fac81b80e21f8702806c', '2026-06-08 16:19:02.316748', 228),
('276fcdbba3bd2631e13324c2da9ae0027867d05f', '2026-06-11 04:58:22.422476', 383),
('2b6dcb28b121da985dda8ded7d394d9154a8739c', '2026-06-08 16:07:10.409430', 214),
('2d30a12a1fa640c9b45c1e15c84978c40cd9f615', '2026-06-08 18:19:53.947510', 264),
('2de54163686fd3c909efc808a2509d58bf23d16a', '2026-06-11 04:58:20.716178', 381),
('35458a29108e86aed1182ff6c006ce88efc9b72d', '2026-06-08 18:37:45.119948', 267),
('35585e2d436d0f53dad576464a600dd19697e75a', '2026-06-08 14:17:48.713953', 194),
('3574e9d66c9802cc8edb6d7fa733ebb939de8cff', '2026-06-09 08:45:09.859904', 355),
('395d61f28555a07c920fdb752d4dc7bb782a9ec7', '2026-06-11 05:15:04.121452', 393),
('3b781720a8821b97202fe7bb9d87d9ed632ac0a3', '2026-06-08 14:29:22.288502', 198),
('3b9e86ded8b48af224b21d348ca11ee30e8399b6', '2026-06-08 21:15:05.854299', 313),
('3bd6ce1e20c811e004e9db5a61b08d86315ccf01', '2026-06-09 08:45:27.754135', 360),
('3bef4c11629ada8fe54d54d957d18abeadc25d37', '2026-06-08 18:16:50.957789', 261),
('3c52fda46ce6e649a45b81faef897f0871ad3275', '2026-06-11 05:17:27.441389', 404),
('3d29636646a436a4745fff5d4b71ccc7b30a6668', '2026-06-08 16:07:23.367902', 215),
('3d7eb7b3705f503a27555751ec6617a43c4f9d2e', '2026-06-08 21:49:42.999046', 316),
('3efdea88496da7f627d625c207f0028572101696', '2026-06-08 21:49:41.801904', 315),
('4126fcb69067b909da9904bda93053f62bc1e0a2', '2026-06-08 20:06:50.955483', 279),
('412d2624b5648a180747a10891af57abc0f5f9a5', '2026-06-09 08:45:02.514322', 354),
('41fce7e92ef90a2648906d83eb4c49cf43a18271', '2026-06-08 15:33:03.592583', 210),
('42fec9281c0b50b39ef55e8f966e8e800d284e93', '2026-06-09 08:44:39.994048', 349),
('46f84f06ce994dad883a5f96d0751a71dfa82b03', '2026-06-09 08:44:40.810708', 350),
('47536540f13ca747feede3a2aa700dd59823bea7', '2026-06-08 20:06:39.613752', 275),
('48c0b1ebbb31fd00e99859debbdc3b513472a475', '2026-06-08 20:44:55.394673', 289),
('4bd139f144f37cc32f39d622c21ab13aeb722337', '2026-06-11 05:15:33.083893', 399),
('4d280e72e13156c27840630a241d615142847a49', '2026-06-08 20:44:50.635551', 287),
('4f9ae9540590a86795609ec5d8807821ac48f6a9', '2026-06-09 08:44:26.923403', 344),
('5015c21ae1a70ae5a2bd2cbf2abb518f3fb62a57', '2026-06-08 17:06:35.229695', 248),
('5041678e1f448a76c00b807d161e36aa3db1492e', '2026-06-09 08:45:12.842693', 356),
('50c1ad37826b1be6291db28f857ea8fd66e0890c', '2026-06-09 07:28:41.545979', 342),
('542443890075a841135b7144a4df455fb1cda2ee', '2026-06-08 20:44:49.826480', 286),
('5569fda67497665944ebcdbfe2ff723642d4030b', '2026-06-08 20:45:56.651807', 293),
('598628ea7f20c2400ffd5632ea76b30a239b8d23', '2026-06-08 16:09:04.888680', 220),
('5ce295fbc7be6bcdb3e40047ea13dfae280b2821', '2026-06-11 04:58:43.590263', 385),
('5d698861829e95cd189b7b0e52557907e571810c', '2026-06-09 08:59:16.649459', 362),
('5dafbb7e9dc63edf11fff49aaaf2170230557072', '2026-06-08 18:37:44.257951', 266),
('5e03735e2747d4ca27e9f6daf9ca46b5d5948a02', '2026-06-08 16:07:08.164457', 213),
('5fc17cde9a0bf06d7e93fc034b017b2fbc92dd17', '2026-06-08 22:33:06.383503', 34),
('5fe399e1827d8f2471a4c8cca43d0654610341ff', '2026-06-08 16:32:05.409320', 238),
('61b14105be750972d4de94164dce3be29b8fc20e', '2026-06-11 04:56:29.842886', 379),
('61e03803be2342e496e0528c9a1486b3cfe24ebf', '2026-06-11 05:07:11.961749', 390),
('624d74622816ab5d5de3fef950780048adbf982d', '2026-06-09 03:56:01.823679', 335),
('64b40780fed11a4ec7c0ee1fb78566f76c6c2316', '2026-06-08 15:28:12.767852', 209),
('6562b1613295e4a4a524674ebc3de01b192dfb09', '2026-06-08 14:29:17.058331', 196),
('6658c4166d551ead8731f4beb4e334e4619fbc78', '2026-06-08 20:57:31.811984', 298),
('66a03f1b9756596583199819aa6b19dece75aab3', '2026-06-08 18:16:53.094190', 263),
('66a98e5e6482516bef42e9719b33560464bde5ba', '2026-06-09 03:42:01.555936', 330),
('67098431e5bc588fd996d379015ab61586534340', '2026-06-08 20:44:51.952766', 288),
('67f0959c54c2319dee6f25fb18c69d0e804235d7', '2026-06-11 04:55:43.577411', 373),
('684ac6e2806ce3c0fd44be89c542eeed06f25572', '2026-06-09 03:00:26.870574', 328),
('687c51f21b86924ab11b75ee6a0402d10770fcd3', '2026-06-08 18:16:51.729153', 262),
('68bce38226ce9fb03739111c44ef1d1f04fd1cef', '2026-06-08 15:03:50.396458', 206),
('69d1a447aa5e6076c6c837e4dc4779d1ad16235d', '2026-06-08 21:49:44.356065', 317),
('6a2f5483362dfbff77b2e959c2d5abdda386a837', '2026-06-08 16:19:22.336761', 232),
('6b5ff60af9ab1b08c7cb6e95866b783cf494c4e2', '2026-06-08 14:27:38.325622', 94),
('6bdcff6b41092178fe61e0cc601e5b5632dd8972', '2026-06-11 05:17:28.012251', 405),
('6eb809acc3945ae2fea29e3d0fecf7369dd0fdd9', '2026-06-08 17:06:36.008806', 249),
('6f022ae278916af6e2fb21bb0ec1d1e649e24842', '2026-06-08 17:03:28.858670', 245),
('735c5fcd710b4e36b4284db60ef7b161c757baf1', '2026-06-09 02:45:02.820809', 322),
('7375b18be0ce25582cfa91d591fba1fedd66c3e8', '2026-06-11 05:15:05.660859', 395),
('739af1265b507d51e32f61a2b6cc213ed7a89cef', '2026-06-08 18:16:43.571419', 259),
('75877e909b9c691633f469b3c860f7502d718394', '2026-06-09 03:42:03.274381', 332),
('75d851cfd3e44fc235d9f028d9de309a1ed2547f', '2026-06-08 16:19:17.702420', 230),
('7a072a5bbda7884ded3d3383477614ff0a699efe', '2026-06-11 04:58:45.374563', 387),
('7a8a89adcb49d2442f9b63f28b0d329dd68c1970', '2026-06-08 15:19:18.508780', 208),
('7da77c527be861b53d80f53790ad0de958e9c5b8', '2026-06-08 16:42:28.707042', 242),
('7e02ab12e9975e584541a89d2a87cc97bb407b61', '2026-06-08 16:04:51.604450', 50),
('7ffbf2ab80645226bca85e8be62487da13fb3897', '2026-06-11 04:54:05.656840', 370),
('808110202cf7f844a693f6e9bfe57ea98e61132b', '2026-06-11 05:15:04.920534', 394),
('808164d42cbff497e40849bced55ae7a6b597b6d', '2026-06-11 04:56:28.175137', 377),
('876f9c9598bbed7079e4058ea16fa55c902f8538', '2026-06-09 08:44:32.896462', 345),
('89c4fe2f5ebf7957a3c0fd88836d9acb0b982010', '2026-06-10 06:05:55.211393', 363),
('8cc5c281a297666edc98a25baa20e125ed5b2a5e', '2026-06-08 19:16:03.237877', 51),
('8e5809eda7939332483eb520300d7392a5920e00', '2026-06-08 21:15:05.372563', 312),
('8f90854d2e4ceab886a2ed7dbb8deaa460a6a1cc', '2026-06-08 21:15:00.716240', 310),
('907f0d5a383546385879a742ce20b0ac487285a2', '2026-06-09 03:42:02.327484', 331),
('918f8743749a19e21c02c9e6cdcb6e469fdc445d', '2026-06-08 16:07:24.308873', 216),
('93a48cced7cfa3479c2bd3303a37bd182849e4c6', '2026-06-08 14:38:29.385361', 201),
('971d71f0fbd8478cc852fadbaa204066ba6237f2', '2026-06-11 05:15:06.377911', 397),
('9722c72fa7632599cde5862bb684054e3611010d', '2026-06-08 20:07:00.326584', 284),
('9764e39b2fcdf910ee7458db4ffbd9ece103e175', '2026-06-08 18:16:41.502368', 257),
('9c650077bba25a19c5c17e795fd500cbd537616f', '2026-06-08 20:58:08.770602', 301),
('9cda7cd7f85352f8db3ebf8c0383560fbb9baec0', '2026-06-08 21:15:04.901146', 311),
('9d2fc7f4e02e89ad008f9c9d233aa249a5dbd586', '2026-06-09 08:52:53.499473', 361),
('9f907f3daa17ce3353e7a16bc0beef18ef96fb34', '2026-06-09 02:45:03.588581', 323),
('a116d8cf9b782e31833a0775f1ed83e8b832a71d', '2026-06-08 16:07:25.364659', 217),
('a246e922c84ad0664d1c8fe078da57e4383b0652', '2026-06-09 08:45:15.019027', 357),
('a292c1bf434c21cfc1977dcdae5a478bb5cfb2cf', '2026-06-09 04:03:11.836860', 341),
('a309224269b5f5512dd1c25b0228a117a6e55a43', '2026-06-08 16:42:29.467134', 243),
('a355862608c7498e5620fb9e429145d841975ff8', '2026-06-08 20:06:37.410899', 274),
('a4731d2c6b15249f47393adcdaf4008159aa9c17', '2026-06-08 18:37:46.433753', 268),
('a737bf973b26fd331f491809588f81da2b4dbd1b', '2026-06-11 04:55:44.474164', 374),
('a7c3ddb56071a614b4b3f1573412bbed022d49fa', '2026-06-08 15:52:11.139459', 211),
('ac0a7220b556e14de36e19b9cc5502a4c066ce59', '2026-06-09 06:14:10.163718', 92),
('ac770f628f7c00447d2662454f92c5732b0cbf91', '2026-06-09 03:56:02.675641', 336),
('ad08c4b1d4651ef0065288e163d6337939b84bc8', '2026-06-11 04:58:21.549775', 382),
('ad0c77ca49fb9cd43362bd768902bd91403f4232', '2026-06-08 14:29:17.788809', 197),
('adb8f5f402e546ecc8c34cca38956da7b4aa3244', '2026-06-08 17:23:08.886241', 254),
('ae7839107cbd2709bceb8386f5492c0ea0fbc534', '2026-06-08 17:11:13.350069', 252),
('aebe5ed57e1ae324c1c3bce00157b60023f99393', '2026-06-11 04:54:06.713422', 371),
('b0da4ff4db1bf5dd2bff8bb11af644dd615be723', '2026-06-11 05:17:45.855967', 412),
('b3a6173a6ad360f6260cc7c92efa7951c07e3338', '2026-06-11 04:23:10.008238', 365),
('b419e69ca6cada8ac48dcd3003c9db952b9327e0', '2026-06-08 20:44:55.879583', 290),
('b5712226af7d3eec82d0274893f5ef93543f6555', '2026-06-09 02:45:04.455508', 324),
('b697635649828679be12049d24ba901da3553e42', '2026-06-08 21:49:49.559168', 319),
('b84092c52629e156f798d6f80d0c5fcf3fbd7dd0', '2026-06-08 20:06:36.174565', 273),
('bc01d4911163dcb39f8c836ce70b2b18b273fac0', '2026-06-09 08:44:37.756943', 348),
('beeb066f028ae2496afcd0d9b6f0c5a3728c1637', '2026-06-09 04:03:10.940940', 340),
('bf7d7ddadb48cc2f7e316549f291140757ee30da', '2026-06-09 08:45:22.565899', 359),
('c039a96aa4651090d2c336b79d1494ecc5f0aa89', '2026-06-09 08:44:25.015296', 343),
('c0e5e5b71c3f5481d7c79d6af551cc9131392ffb', '2026-06-08 16:19:18.464067', 231),
('c49a3f4d8f39ae12690b823ca86117fb4f2ce830', '2026-06-09 08:45:22.167014', 358),
('c4c7c1a3304872b0301d7f7a36a4e54b27768a18', '2026-06-08 20:06:59.591200', 283),
('c4e3abed7baeeaa1d7f121a5e784867af1ef4723', '2026-06-11 05:52:36.842479', 414),
('c6dbd5f23249fdeb3449497c2fa8cc1c7920806f', '2026-06-08 16:07:55.624906', 218),
('c8592be4f49c4b7e3de17fe87e65ef0ebf32f23a', '2026-06-08 14:29:22.691069', 199),
('c96e47d1d2f5a4f6cbfe27e69adc6c354adb2e83', '2026-06-08 20:06:44.645549', 277),
('c982e45dcbfde8c94a7fa2218f6b64a2f0d288dc', '2026-06-08 14:29:23.102576', 200),
('cb5ee5f1ff06e99b57b0b55f7e33780f7a20b689', '2026-06-08 21:49:49.092705', 318),
('ce081684b831810c34e9b31db5709b0466c7b037', '2026-06-08 15:03:49.351539', 205),
('d03b61ef9f7f46402b49529bfd07271d6d9f8c8a', '2026-06-09 08:44:50.914956', 351),
('d08ddc303d622f635c04d521b58da22ac7471fde', '2026-06-08 20:06:58.890400', 282),
('d0a652892ef69eea63fb8b08395fb27f84a3fbb4', '2026-06-09 08:44:35.804809', 347),
('d46ab0962db4c9cf77e82451a6e4b75936a29bb8', '2026-06-08 16:09:17.413328', 222),
('d5713bd25b4d4252285dcee596e94c6391614d47', '2026-06-08 20:06:51.673131', 280),
('d5c7af34e277aa730b6cc56a2e3bdc1ce25a89d9', '2026-06-11 05:17:28.607362', 406),
('d77f4c25593e34168f65d28e84a391075265502b', '2026-06-13 07:16:54.986214', 415),
('dae132b70e7dce569e2f333499deb93f9dd6b5df', '2026-06-08 17:23:10.118460', 255),
('db7f7c8dc8fbf469e318024afeda5f37a872400a', '2026-06-08 20:58:09.641868', 302),
('dc7376f4f309fdc05e349142e13291be9ecb135e', '2026-06-08 16:09:18.199796', 223),
('dcbbe3dcb24cae3c91f240f2bae71cbe467d083a', '2026-06-09 08:44:53.090084', 352),
('e15e290ac6b903d36b57aae8b0e66e5a70a54e71', '2026-06-11 05:17:44.711158', 410),
('e2f1177cbe1d6363152c2e578185dfaf29bc41a0', '2026-06-08 20:58:15.969109', 306),
('e316b4591e89c4e5702da1189151f59276ef92bd', '2026-06-08 21:49:50.014438', 320),
('e3f204b841dc460774860f066701382e42871b9d', '2026-06-08 15:03:51.783549', 207),
('e4056632b6243fb4071988d85ea62920779ec9b6', '2026-06-08 15:39:00.762612', 53),
('e4f43c8adad23038e70276c52bf092a624662050', '2026-06-08 20:58:15.020677', 304),
('e65b428b1b758af3e713f823c36f0acbf2082ba5', '2026-06-08 21:14:59.392987', 309),
('e74bd9c34838441d3faf7a505cf174674282e11b', '2026-06-11 04:50:14.325822', 367),
('e7d9be36e1388744e4e421d23dc66d1cf652c10d', '2026-06-08 20:06:43.894442', 276),
('ee16dd3b783d0a8c1d3893375954e61fd0b3cd9a', '2026-06-11 05:07:10.971279', 389),
('ee69b648a16e4121e44e5e176624bf754b5b022d', '2026-06-08 20:57:30.961139', 297),
('f01984876e5f6a356ccb5690478b63615a11a2aa', '2026-06-08 20:58:11.042633', 303),
('f0b18f5d69c72b173674b43ab4a38ff6f393eab0', '2026-06-08 16:09:22.959156', 225),
('f1f48e57cfdca70683c9ec3e93a974c4b908a9c6', '2026-06-11 04:58:44.485017', 386),
('f2d7b6aca9d9f43aed8aee7aa1f8238e116cf888', '2026-06-09 04:03:10.153514', 339),
('f2fe4af3d49653308a76e818cfa9b8d8fb0bee42', '2026-06-08 14:38:37.898705', 203),
('f46d470be676c790e582991dd7ef5dbf16df6c51', '2026-06-11 04:56:28.968967', 378),
('f565062dd1663a392e6fb9c3feba731c0fbbc2c7', '2026-06-08 20:45:58.885195', 295),
('f787eff77b5ec57f796fd2ba8b97c363df831e4d', '2026-06-11 05:15:07.050527', 398),
('f89dd32165500536b1147a92b364f8c8f5ff6c17', '2026-06-09 08:44:35.358501', 346),
('f9696ab3bd2be118e0fc61f36f5941af3807d6e7', '2026-06-08 17:03:29.629738', 246),
('fc8528767d3f20967a4936729ad65cbad6e53a0e', '2026-06-08 16:19:22.740921', 233),
('fea2bf5bd901799de19aa85e000805e4562a475b', '2026-06-08 16:19:23.146617', 234),
('ff6424a709a92a17872c97b41af9f6d7a25a5576', '2026-06-08 20:57:33.190267', 299),
('ff83e22a9e0eefa41a3c6e2d130849e8943cc76b', '2026-06-11 04:32:06.540628', 366);

-- --------------------------------------------------------

--
-- 資料表結構 `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- 傾印資料表的資料 `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add content type', 4, 'add_contenttype'),
(14, 'Can change content type', 4, 'change_contenttype'),
(15, 'Can delete content type', 4, 'delete_contenttype'),
(16, 'Can view content type', 4, 'view_contenttype'),
(17, 'Can add session', 5, 'add_session'),
(18, 'Can change session', 5, 'change_session'),
(19, 'Can delete session', 5, 'delete_session'),
(20, 'Can view session', 5, 'view_session'),
(21, 'Can add Token', 6, 'add_token'),
(22, 'Can change Token', 6, 'change_token'),
(23, 'Can delete Token', 6, 'delete_token'),
(24, 'Can view Token', 6, 'view_token'),
(25, 'Can add Token', 7, 'add_tokenproxy'),
(26, 'Can change Token', 7, 'change_tokenproxy'),
(27, 'Can delete Token', 7, 'delete_tokenproxy'),
(28, 'Can view Token', 7, 'view_tokenproxy'),
(29, 'Can add user', 8, 'add_user'),
(30, 'Can change user', 8, 'change_user'),
(31, 'Can delete user', 8, 'delete_user'),
(32, 'Can view user', 8, 'view_user'),
(33, 'Can add address', 9, 'add_address'),
(34, 'Can change address', 9, 'change_address'),
(35, 'Can delete address', 9, 'delete_address'),
(36, 'Can view address', 9, 'view_address'),
(37, 'Can add court', 10, 'add_court'),
(38, 'Can change court', 10, 'change_court'),
(39, 'Can delete court', 10, 'delete_court'),
(40, 'Can view court', 10, 'view_court'),
(41, 'Can add facility', 11, 'add_facility'),
(42, 'Can change facility', 11, 'change_facility'),
(43, 'Can delete facility', 11, 'delete_facility'),
(44, 'Can view facility', 11, 'view_facility'),
(45, 'Can add penalty rule', 12, 'add_penaltyrule'),
(46, 'Can change penalty rule', 12, 'change_penaltyrule'),
(47, 'Can delete penalty rule', 12, 'delete_penaltyrule'),
(48, 'Can view penalty rule', 12, 'view_penaltyrule'),
(49, 'Can add sport', 13, 'add_sport'),
(50, 'Can change sport', 13, 'change_sport'),
(51, 'Can delete sport', 13, 'delete_sport'),
(52, 'Can view sport', 13, 'view_sport'),
(53, 'Can add blacklist', 14, 'add_blacklist'),
(54, 'Can change blacklist', 14, 'change_blacklist'),
(55, 'Can delete blacklist', 14, 'delete_blacklist'),
(56, 'Can view blacklist', 14, 'view_blacklist'),
(57, 'Can add feedback', 15, 'add_feedback'),
(58, 'Can change feedback', 15, 'change_feedback'),
(59, 'Can delete feedback', 15, 'delete_feedback'),
(60, 'Can view feedback', 15, 'view_feedback'),
(61, 'Can add game match', 16, 'add_gamematch'),
(62, 'Can change game match', 16, 'change_gamematch'),
(63, 'Can delete game match', 16, 'delete_gamematch'),
(64, 'Can view game match', 16, 'view_gamematch'),
(65, 'Can add notification', 17, 'add_notification'),
(66, 'Can change notification', 17, 'change_notification'),
(67, 'Can delete notification', 17, 'delete_notification'),
(68, 'Can view notification', 17, 'view_notification'),
(69, 'Can add report', 18, 'add_report'),
(70, 'Can change report', 18, 'change_report'),
(71, 'Can delete report', 18, 'delete_report'),
(72, 'Can view report', 18, 'view_report'),
(73, 'Can add venue', 19, 'add_venue'),
(74, 'Can change venue', 19, 'change_venue'),
(75, 'Can delete venue', 19, 'delete_venue'),
(76, 'Can view venue', 19, 'view_venue'),
(77, 'Can add court conflict', 20, 'add_courtconflict'),
(78, 'Can change court conflict', 20, 'change_courtconflict'),
(79, 'Can delete court conflict', 20, 'delete_courtconflict'),
(80, 'Can view court conflict', 20, 'view_courtconflict'),
(81, 'Can add favorite game', 21, 'add_favoritegame'),
(82, 'Can change favorite game', 21, 'change_favoritegame'),
(83, 'Can delete favorite game', 21, 'delete_favoritegame'),
(84, 'Can view favorite game', 21, 'view_favoritegame'),
(85, 'Can add match participant', 22, 'add_matchparticipant'),
(86, 'Can change match participant', 22, 'change_matchparticipant'),
(87, 'Can delete match participant', 22, 'delete_matchparticipant'),
(88, 'Can view match participant', 22, 'view_matchparticipant'),
(89, 'Can add user sport level', 23, 'add_usersportlevel'),
(90, 'Can change user sport level', 23, 'change_usersportlevel'),
(91, 'Can delete user sport level', 23, 'delete_usersportlevel'),
(92, 'Can view user sport level', 23, 'view_usersportlevel'),
(93, 'Can add game bulletin', 24, 'add_gamebulletin'),
(94, 'Can change game bulletin', 24, 'change_gamebulletin'),
(95, 'Can delete game bulletin', 24, 'delete_gamebulletin'),
(96, 'Can view game bulletin', 24, 'view_gamebulletin');

-- --------------------------------------------------------

--
-- 資料表結構 `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- 傾印資料表的資料 `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(1, '2026-06-07 15:19:16.961683', '6', 'air (air005831@gmail.com)', 3, '', 8, 33),
(2, '2026-06-07 15:19:29.383426', '28', 'Test Gender (test_gender@example.com)', 3, '', 8, 33),
(3, '2026-06-07 15:21:07.306431', '34', 'air (air005831@gmail.com)', 2, '[]', 8, 33),
(4, '2026-06-08 10:17:16.343116', '1', '楊鑫 (None)', 2, '', 8, 1),
(5, '2026-06-08 14:39:22.571597', '51', '桃園市我家123我家123', 3, '', 9, 109),
(6, '2026-06-08 14:39:29.827647', '50', '桃園市我家我家', 3, '', 9, 109),
(7, '2026-06-08 16:11:31.047495', '1', 'Feedback object (1)', 3, '', 15, 109),
(8, '2026-06-08 16:35:39.145944', '2', 'Feedback object (2)', 2, '[{\"changed\": {\"fields\": [\"Admin reply\"]}}]', 15, 109),
(9, '2026-06-08 16:36:20.960856', '2', 'Feedback object (2)', 2, '[{\"changed\": {\"fields\": [\"Admin reply\"]}}]', 15, 109),
(10, '2026-06-11 14:26:11.215248', '2', '冷氣機', 2, '[]', 11, 34);

-- --------------------------------------------------------

--
-- 資料表結構 `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- 傾印資料表的資料 `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(9, 'api_v1', 'address'),
(25, 'api_v1', 'announcement'),
(14, 'api_v1', 'blacklist'),
(10, 'api_v1', 'court'),
(20, 'api_v1', 'courtconflict'),
(11, 'api_v1', 'facility'),
(21, 'api_v1', 'favoritegame'),
(15, 'api_v1', 'feedback'),
(24, 'api_v1', 'gamebulletin'),
(16, 'api_v1', 'gamematch'),
(22, 'api_v1', 'matchparticipant'),
(17, 'api_v1', 'notification'),
(12, 'api_v1', 'penaltyrule'),
(18, 'api_v1', 'report'),
(13, 'api_v1', 'sport'),
(8, 'api_v1', 'user'),
(23, 'api_v1', 'usersportlevel'),
(19, 'api_v1', 'venue'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(6, 'authtoken', 'token'),
(7, 'authtoken', 'tokenproxy'),
(4, 'contenttypes', 'contenttype'),
(5, 'sessions', 'session');

-- --------------------------------------------------------

--
-- 資料表結構 `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- 傾印資料表的資料 `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2026-06-06 13:00:44.261414'),
(2, 'api_v1', '0001_initial', '2026-06-06 13:00:44.315062'),
(3, 'admin', '0001_initial', '2026-06-06 13:00:44.473761'),
(4, 'admin', '0002_logentry_remove_auto_add', '2026-06-06 13:00:44.484078'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2026-06-06 13:00:44.491895'),
(6, 'contenttypes', '0002_remove_content_type_name', '2026-06-06 13:00:44.598465'),
(7, 'auth', '0001_initial', '2026-06-06 13:00:45.021072'),
(8, 'auth', '0002_alter_permission_name_max_length', '2026-06-06 13:00:45.117755'),
(9, 'auth', '0003_alter_user_email_max_length', '2026-06-06 13:00:45.123199'),
(10, 'auth', '0004_alter_user_username_opts', '2026-06-06 13:00:45.129500'),
(11, 'auth', '0005_alter_user_last_login_null', '2026-06-06 13:00:45.137768'),
(12, 'auth', '0006_require_contenttypes_0002', '2026-06-06 13:00:45.144995'),
(13, 'auth', '0007_alter_validators_add_error_messages', '2026-06-06 13:00:45.151446'),
(14, 'auth', '0008_alter_user_username_max_length', '2026-06-06 13:00:45.157282'),
(15, 'auth', '0009_alter_user_last_name_max_length', '2026-06-06 13:00:45.162957'),
(16, 'auth', '0010_alter_group_name_max_length', '2026-06-06 13:00:45.182736'),
(17, 'auth', '0011_update_proxy_permissions', '2026-06-06 13:00:45.195908'),
(18, 'auth', '0012_alter_user_first_name_max_length', '2026-06-06 13:00:45.201373'),
(19, 'authtoken', '0001_initial', '2026-06-06 13:00:45.282074'),
(20, 'authtoken', '0002_auto_20160226_1747', '2026-06-06 13:00:45.324649'),
(21, 'authtoken', '0003_tokenproxy', '2026-06-06 13:00:45.329785'),
(22, 'authtoken', '0004_alter_tokenproxy_options', '2026-06-06 13:00:45.334499'),
(23, 'sessions', '0001_initial', '2026-06-06 13:00:45.379869'),
(24, 'api_v1', '0002_alter_composite_pks', '2026-06-06 14:46:33.038410'),
(25, 'api_v1', '0003_remove_gamematch_created_at', '2026-06-06 14:46:33.049125'),
(26, 'api_v1', '0004_gamebulletin', '2026-06-06 15:09:22.157102');

-- --------------------------------------------------------

--
-- 資料表結構 `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- 傾印資料表的資料 `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('2n7pkcc3yryv9nj2382riksf078fj3zs', '.eJxVjDsOwjAQBe_iGlnxP6akzxmstXeNA8iW4qRC3J1ESgHtm5n3ZgG2tYSt0xJmZFfmJbv8jhHSk-pB8AH13nhqdV3myA-Fn7TzqSG9bqf7d1Cgl712lBXoqLTVJlunRDI5CyVzsnFHUlgxeBgTghwleCMcRhqyR5SE5BP7fAESdTjO:1wWeE1:R3BvtrTwyYn8MmGGg_QoGhi_E6l88S1j-rNAHc3Pjjc', '2026-06-22 17:57:25.918619'),
('3kng2i0yzsia28htvn3fpina8ntf7abf', '.eJxVjDsOwjAQBe_iGlnxP6akzxmstXeNA8iW4qRC3J1ESgHtm5n3ZgG2tYSt0xJmZFfmJbv8jhHSk-pB8AH13nhqdV3myA-Fn7TzqSG9bqf7d1Cgl712lBXoqLTVJlunRDI5CyVzsnFHUlgxeBgTghwleCMcRhqyR5SE5BP7fAESdTjO:1wWno1:Kk7lOI9_8g798Sv5O-5Q7f6X6mFcLro2A_YYTR2NbbU', '2026-06-23 04:11:13.444245'),
('8dta170s2jvfpa2vk5t0xy91mvz2enep', '.eJxVjDsOwjAQBe_iGlnxP6akzxmstXeNA8iW4qRC3J1ESgHtm5n3ZgG2tYSt0xJmZFfmJbv8jhHSk-pB8AH13nhqdV3myA-Fn7TzqSG9bqf7d1Cgl712lBXoqLTVJlunRDI5CyVzsnFHUlgxeBgTghwleCMcRhqyR5SE5BP7fAESdTjO:1wWohy:FuyuJSv14AsFRp_bLhDsD_ATKAJ_AU_VFmnvkKPVtFE', '2026-06-23 05:09:02.348675'),
('97k9skss8tt62dj0keokzfz10aueyh0k', '.eJxVjDsOwyAQBe9CHSFgQUDK9DkD2uUTnEQgGbuycvfYkoukfTPzNhZwXWpYR57DlNiVSeHZ5XcljK_cDpSe2B6dx96WeSJ-KPykg997yu_b6f4dVBx1rxGRMigw2gJ4V7S0xopUtCIU3njhIzgistJilJhEcUq5BEbujfSCfb4f2Tdo:1wWYnH:IGGfyM_O54WkNERRTclHD0XCGvGnbjpHCFmDtURtpQc', '2026-06-22 12:09:27.941921'),
('abfywaj8z5b4x91ogbx4lui5a14mm8v5', '.eJxVjDsOwyAQBe9CHSFgQUDK9DkD2uUTnEQgGbuycvfYkoukfTPzNhZwXWpYR57DlNiVSeHZ5XcljK_cDpSe2B6dx96WeSJ-KPykg997yu_b6f4dVBx1rxGRMigw2gJ4V7S0xopUtCIU3njhIzgistJilJhEcUq5BEbujfSCfb4f2Tdo:1wWYCq:Pf-bJFXCSxtMWXMUW5HQYUNOtDglq6ZSczZbaIuNtX4', '2026-06-22 11:31:48.544465'),
('anh1zoiylh7gpcsoz2snq06cjls0p3vu', '.eJxVjMsOwiAQRf-FtSFAh0dduvcbyNAZpGogKe3K-O_apAvd3nPOfYmI21ri1nmJM4mzGECcfseE04PrTuiO9dbk1Oq6zEnuijxol9dG_Lwc7t9BwV6-dYYBGXxQIVh0wVhHyYPOKiTHWSWrmIwbgUFbbbzVSeHkCAG9D3ok8f4A8m83ew:1wWY1C:fL2D5lGyKH0vFQcHMDKwxaBlnt76PCTVz3SWpgS2bnc', '2026-06-22 11:19:46.408449'),
('ex3ptq62c7k8yp4p1y1hf4plw41078x7', '.eJxVjDsOwyAQBe9CHSFgQUDK9DkD2uUTnEQgGbuycvfYkoukfTPzNhZwXWpYR57DlNiVSeHZ5XcljK_cDpSe2B6dx96WeSJ-KPykg997yu_b6f4dVBx1rxGRMigw2gJ4V7S0xopUtCIU3njhIzgistJilJhEcUq5BEbujfSCfb4f2Tdo:1wWYnG:UzQYrtqyHe2dZgR-KJTvbvLdVWDxgqf9BK8DnLtbkGE', '2026-06-22 12:09:26.349412'),
('ksup9x1ew8onnzynbelb0pv1p3m8u68a', '.eJxVjMsOwiAQRf-FtSHDS8Cl-34DYZiJVA0kpV0Z_12bdKHbe865L5Hytta0DV7STOIilDj9bpjLg9sO6J7brcvS27rMKHdFHnTIqRM_r4f7d1DzqN_aBiDwBnSBM0VlQ8xMMRgfkLXDiGzQsiNNFkzU1rEChKyKUj5aLuL9AcM2NzU:1wWnSt:AiICUiujzkIj5AlknitzjNC5pPPWPQpnfX2ogpLFqok', '2026-06-23 03:49:23.966977'),
('l5xtp43itofri0oh8odp9u1afbdxhywr', '.eJxVjDsOwyAQBe9CHSFgQUDK9DkD2uUTnEQgGbuycvfYkoukfTPzNhZwXWpYR57DlNiVSeHZ5XcljK_cDpSe2B6dx96WeSJ-KPykg997yu_b6f4dVBx1rxGRMigw2gJ4V7S0xopUtCIU3njhIzgistJilJhEcUq5BEbujfSCfb4f2Tdo:1wWmWs:Dk21RP89uNIJ-9mNt0UYzOgcmV91dQ7qa84mS50Bq_E', '2026-06-23 02:49:26.808189'),
('rw7tcahnzl64kq8tgmsvr25i9dvhwe3x', '.eJxVjDsOwjAQBe_iGlnxP6akzxmstXeNA8iW4qRC3J1ESgHtm5n3ZgG2tYSt0xJmZFfmJbv8jhHSk-pB8AH13nhqdV3myA-Fn7TzqSG9bqf7d1Cgl712lBXoqLTVJlunRDI5CyVzsnFHUlgxeBgTghwleCMcRhqyR5SE5BP7fAESdTjO:1wWeEM:VgKUmWlMNXITCEAa8UAtOvwdcSeDwztUAjsqL5O85Pk', '2026-06-22 17:57:46.065074'),
('uaajlps00li898u8p9xxcmps0r4nyeyo', '.eJxVjMsOwiAQRf-FtSHDS8Cl-34DYZiJVA0kpV0Z_12bdKHbe865L5Hytta0DV7STOIilDj9bpjLg9sO6J7brcvS27rMKHdFHnTIqRM_r4f7d1DzqN_aBiDwBnSBM0VlQ8xMMRgfkLXDiGzQsiNNFkzU1rEChKyKUj5aLuL9AcM2NzU:1wWnGg:fQ7be8Zn2XWEqQtoWaWwdRSyzspxgMNj_v4lVtKhKqA', '2026-06-23 03:36:46.454568'),
('xarhe770e893dkzcydaod4oiuuumu95u', '.eJxVjDsOwjAQBe_iGlnxP6akzxmstXeNA8iW4qRC3J1ESgHtm5n3ZgG2tYSt0xJmZFfmJbv8jhHSk-pB8AH13nhqdV3myA-Fn7TzqSG9bqf7d1Cgl712lBXoqLTVJlunRDI5CyVzsnFHUlgxeBgTghwleCMcRhqyR5SE5BP7fAESdTjO:1wXWsd:Kx3WoAvdWBkhLLIir7kNyycvk24eZDcEpjLzqRFMWbU', '2026-06-25 04:18:59.346406'),
('ze3bxf15stvolp3j91varqoctpzs5ywg', '.eJxVjEEOwiAQRe_C2hAGKlNcuu8ZyMCAVA0kpV0Z765NutDtf-_9l_C0rcVvPS1-ZnERZhCn3zFQfKS6E75TvTUZW12XOchdkQftcmqcntfD_Tso1Mu31kTBjGzdGBxpyANaMyiywDHHBDYQ6cyIGI1L2p4VKiAwCR0Agrbi_QEQ5Dea:1wXgLj:R_NVcHOq4CcK3XOZkh_ZwmFMsiRlv90mZPpLeKZbsKE', '2026-06-25 14:25:39.749651');

-- --------------------------------------------------------

--
-- 替換檢視表以便查看 `users`
-- (請參考以下實際畫面)
--
CREATE TABLE `users` (
`user_id` int(11)
,`role` enum('user','admin')
,`name` varchar(100)
,`credit_point` int(11)
,`phone` varchar(20)
,`birth_date` date
,`gender` enum('男','女','其他','不願透漏')
,`avatar_url` varchar(255)
,`bio` text
,`password` varchar(255)
,`line_id` varchar(50)
,`instagram` varchar(50)
,`email` varchar(255)
);

-- --------------------------------------------------------

--
-- 檢視表結構 `users`
--
DROP TABLE IF EXISTS `users`;

CREATE ALGORITHM=UNDEFINED DEFINER=`partner_dev`@`%` SQL SECURITY DEFINER VIEW `users`  AS SELECT `nojo`.`users`.`user_id` AS `user_id`, `nojo`.`users`.`role` AS `role`, `nojo`.`users`.`name` AS `name`, `nojo`.`users`.`credit_point` AS `credit_point`, `nojo`.`users`.`phone` AS `phone`, `nojo`.`users`.`birth_date` AS `birth_date`, `nojo`.`users`.`gender` AS `gender`, `nojo`.`users`.`avatar_url` AS `avatar_url`, `nojo`.`users`.`bio` AS `bio`, `nojo`.`users`.`password` AS `password`, `nojo`.`users`.`line_id` AS `line_id`, `nojo`.`users`.`instagram` AS `instagram`, `nojo`.`users`.`email` AS `email` FROM `nojo`.`users` ;

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `authtoken_token`
--
ALTER TABLE `authtoken_token`
  ADD PRIMARY KEY (`key`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- 資料表索引 `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- 資料表索引 `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- 資料表索引 `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- 資料表索引 `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6` (`user_id`);

--
-- 資料表索引 `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- 資料表索引 `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- 資料表索引 `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- 在傾印的資料表使用自動遞增(AUTO_INCREMENT)
--

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- 已傾印資料表的限制式
--

--
-- 資料表的限制式 `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- 資料表的限制式 `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- 資料表的限制式 `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
