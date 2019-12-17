//
//  ProfileViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/20.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import ALCameraViewController
import YPImagePicker
import MapKit
let items = 8

let arrayCard : [NSDictionary] = [
    ["memberName": "Oliva Wilson",
     "memberId": "xyz123456789",
     "groupNumber": "123456",
     "bin": "987654",
     "benifitPlan": "HIOPT",
     "effectiveDate": "12/12/18",
     "plan": "PPO",
     "officeVisit": "$15",
     "specialistCopay": "$15",
     "emergency": "$75",
     "deductible": "$50",
     ],
]

let arrayCondition : [NSDictionary] = []

let arrayDoctor : [NSDictionary] = [
    ["name": "Dr. Julie Smith", "phone": "(827) 484-1919", "image": "james"],
    ["name": "Dr. Robert Phillip", "phone": "(874) 884-9020", "image": "jess"],
    ["name": "Dr. Tonia Birch", "phone": "(708) 409-0000", "image": "lau"]
]

var arrayPharmacy : [Pharmacy] = [
//    ["name": "CVS Pharmacy", "phone": "(312) 970-2881", "image": "icon_cvs"],
//    ["name": "Walgreens", "phone": "(312) 973-3708", "image": "icon_walgreen"]
]

var arrayCommunity: [CommunityUser] = [
//    ["name": "James Wilson", "image": "james"],
//    ["name": "Jess Wilson", "image": "jess"],
//    ["name": "Dr. Julie Smith", "image": "smith"],
//    ["name": "Dr. Robert Phillip", "image": "hust"],
//    ["name": "Dr. Tonia Birch", "image": "lau"]
]

var arraySchedule : [NSDictionary] = []
//    ["title": "Morning", "timeStart": "5:00am", "timeEnd": "12:00pm", "image": "Morning Icon"],
//    ["title": "Midday", "timeStart": "12:00pm", "timeEnd": "5:00pm", "image": "Midday Icon"],
//    ["title": "Evening", "timeStart": "5:00pm", "timeEnd": "8:00pm", "image": "Evening Icon"],
//    ["title": "Night", "timeStart": "8:00pm", "timeEnd": "12:00am", "image": "Night Icon"]
//]

let arrayApp : [NSDictionary] = [
    ["name": "Alexa", "image": "icon_alexa"],
    ["name": "Fitbit", "image": "icon_fitbit"],
    ["name": "Health", "image": "icon_health"]
]

//let menus = ["Medications","Health Conditions","Pharmacies","Community","Schedules",""]
let menus = ["Medications","Pharmacies","Community","Schedules",""]

var selAvatarImg: UIImage = UIImage()

 let arrayOfContent:[String] = ["Please read these terms of use carefully (“Terms”). These Terms provided by Nexpil, Inc. (“Nexpil”) govern and apply to your access and use of www.nexpil.com and Nexpil's services available via Nexpil's site and Nexpil's mobile apps (collectively, the “Service”). By accessing or using our Service, you agree to be bound to all of the terms and conditions described in these Terms. If you do not agree to all of these terms and conditions, do not use our Service.\nIMPORTANT!!! THE SERVICE IS INTENDED SOLELY AS A TOOL TO ASSIST YOU IN ORGANIZING, UNDERSTANDING AND MANAGING HEALTHCARE-RELATED INFORMATION. THE SERVICE IS NOT INTENDED TO PROVIDE HEALTH OR MEDICAL ADVICE. THE SERVICE IS NOT INTENDED TO (AND DOES NOT) CREATE ANY PATIENT RELATIONSHIP BETWEEN NEXPIL AND YOU, NOR SHOULD IT BE CONSIDERED A REPLACEMENT FOR CONSULTATION WITH A HEALTHCARE PROFESSIONAL. YOU SHOULD NEVER DISREGARD MEDICAL ADVICE OR DELAY SEEKING MEDICAL ADVICE BECAUSE OF SOMETHING YOU HAVE READ ON THE SERVICE OR THE RESULTS YOU RECEIVE THROUGH THE SERVICE.\nIN ADDITION, YOU UNDERSTAND AND AGREE THAT IN PROVIDING THE SERVICE WE RELY ON A NUMBER OF THIRD PARTY PROVIDERS, INCLUDING FOR PURPOSES OF SENDING PUSH NOTIFICATIONS, AND HEREBY DISCLAIM ANY LIABILITY WITH RESPECT TO THE SERVICES PROVIDED BY SUCH PROVIDERS. YOU SHOULD NOT RELY ON THE SERVICE FOR ANY LIFE-THREATENING CONDITION OR ANY OTHER SITUATION WHERE TIMELY ADMINISTRATION OF MEDICATIONS OR OTHER TREATMENT IS CRITICAL.\n\nUSE OF THE SERVICE\n\nNexpil allows you to access and use the Service through our mobile and web-based apps and our site (each an “App”). Via the Services, we offer, among other things, a convenient way to set reminders for prescription medications (“Medications”) and nutritional supplements (“Supplements”), to receive alerts about drug interactions, side effects and recalls based on the Medications you enter into the system, as well as the opportunity to participate in our Gift Program, as described below. You must be at least 18 years of age in order to download and/or use the App.\nAs long as you comply with these Terms, you have the right to download and install a copy of the App to your mobile device, and to access and use the Service, for your own personal use. You may not: (i) copy, modify or distribute the App for any purpose; (ii) transfer, sublicense, lease, lend, rent or otherwise distribute the App or the Service to any third party; (iii) decompile, reverse-engineer, disassemble, or create derivative works of the App or the Service; (iv) make the functionality of the App or the Service available to multiple users through any means; or (v) use the Service in any unlawful manner, for any unlawful purpose, or in any manner inconsistent with these Terms.\nThe following terms apply to any App accessed through or downloaded from any app store or distribution platform (like the Apple App Store or Google Play) where the App may now or in the future be made available (each an “App Provider”). You acknowledge and agree that:\n·       These Terms are concluded between you and Nexpil, and not with the App Provider, and that Nexpil (not the App Provider), is solely responsible for the App.\n·       The App Provider has no obligation to furnish any maintenance and support services with respect to the App.\n·       In the event of any failure of the App to conform to any applicable warranty, you may notify the App Provider, and the App Provider will refund the purchase price for the App to you (if applicable) and to the maximum extent permitted by applicable law, the App Provider will have no other warranty obligation whatsoever with respect to the App. Any other claims, losses, liabilities, damages, costs or expenses attributable to any failure to conform to any warranty will be the sole responsibility of Nexpil.\n·       The App Provider is not responsible for addressing any claims you have or any claims of any third party relating to the App or your possession and use of the App, including, but not limited to: (i) product liability claims; (ii) any claim that the App fails to conform to any applicable legal or regulatory requirement; and (iii) claims arising under consumer protection or similar legislation.\n·       In the event of any third party claim that the App or your possession and use of that App infringes that third party’s intellectual property rights, Nexpil will be solely responsible for the investigation, defense, settlement and discharge of any such intellectual property infringement claim to the extent required by these Terms.\n·       The App Provider, and its subsidiaries, are third party beneficiaries of these Terms as related to your license of the App, and that, upon your acceptance of the terms and conditions of these Terms, the App Provider will have the right (and will be deemed to have accepted the right) to enforce these Terms as related to your license of the App against you as a third party beneficiary thereof.\n·       You must also comply with all applicable third party terms of service when using the App.\nOur Service may change from time to time and/or we may stop (permanently or temporarily) providing the Service (or features within the Service), possibly without prior notice to you. Our Service may include advertisements, which may be targeted to the content or information on the Service, queries made through the Service, or from other information. The types and extent of advertising on the Service are also subject to change over time. In consideration for providing you the Service, you agree that we and our third party providers and partners may place advertising on our Service or in connection with the display of content or information on our Service, and that we may receive remuneration for placing such advertising.\n\nCREATING A NEXPIL ACCOUNT\n\nYou do not need to register to use Nexpil (see Privacy Policy for more details). However, you have the option to register and create an account (your “Account”). If you do so, you represent that you are of legal age to form a binding contract and are not a person barred from receiving services under the laws of the United States or other applicable jurisdiction. When creating an Account, don’t provide any false personal information to us or create any account for anyone other than yourself without such other person's permission.\nWe reserve the right to suspend or terminate your Account if any information provided during the registration process or thereafter proves to be inaccurate, false or that violates our Terms or if you have created more than one Account.\nYou are responsible for maintaining the confidentiality of your password and Account, and agree to notify us if your password is lost, stolen, or disclosed to an unauthorized third party, or otherwise may have been compromised. You are responsible for activities that occur under your Account.\n\nCONTENT SUBMISSIONS\n\nOur Service allows you and other users to post, link, store, share and otherwise make available certain information, images, videos, text and/or other content (\"Content\"). You are responsible for the Content that you post to the Service, including its legality, reliability, and appropriateness. By posting Content to the Service, you grant us the right and license to use, modify, publicly perform, publicly display, reproduce, sell and distribute such Content on and through the Service. You agree that this license includes the right for us to make your Content available to other users of the Service, who may also use your Content subject to these Terms. You retain any and all of your rights to any Content you submit, post or display on or through the Service and you are responsible for protecting those rights.\nYou can remove Content that you posted by specifically deleting it. In certain instances, however, some Content (such as posts or comments you make) may not be completely removed and copies of your Content may continue to exist on the Service and/or elsewhere. We are not responsible or liable for the removal or deletion of (or the failure to remove or delete) any Content on the Service.\nYou represent and warrant that: (i) the Content is yours (you own it) or you have the right to use it and grant us the rights and license as provided in these Terms, and (ii) the posting of your Content on or through the Service does not violate the privacy rights, publicity rights, copyrights, contract rights or any other rights of any person.\nWe ask that you respect our Service and third parties when posting Content and using the Service. When submitting Content to or otherwise using the Service, you agree not to:\n·       submit material that violates a third party’s proprietary rights, including privacy and publicity rights, or that otherwise violates any applicable law;\n·       submit material that is unlawful, obscene, defamatory, libelous, threatening, pornographic, harassing, hateful, racially or ethnically offensive, or encourages conduct that would be considered a criminal offense, give rise to civil liability, violate any law, or is otherwise inappropriate;\n·       impersonate another person or represent yourself as affiliated with us, our staff or other industry professionals; or\n·       harvest user names, addresses, or email addresses for any purpose.\nThis list is an example and is not intended to be complete or exclusive. We don’t have an obligation to monitor your access to or use of the Service or to review or edit any Content, but we have the right to do so for the purpose of operating the Service, to ensure your compliance with these Terms, or to comply with applicable law or the order or requirement of a court, administrative agency or other governmental body. We reserve the right, at any time and without prior notice, to remove or disable access to any Content, that we consider, in our sole discretion, to be in violation of these Terms or otherwise harmful to the Service.\nWe also reserve the right to suspend or terminate your Account and your use of the Service at any time in case of violation by you of these Terms or if Nexpil discontinues providing the Service for any reason.\n\nNEXPIL GIFT PROGRAM\n\nIn connection with the Service, we may make available a user gift program (the “Gift Program”), where you can become eligible to be entered into weekly drawings (“Drawings”) to receive gift cards, charity donations and other items (collectively, “Gifts”) in connection with your accrual of points that you may earn by using the Service (“Nexpil Points”). Nexpil Points can be accumulated by engaging in certain actions via the Service, such as when you take your Medications and Supplements on schedule.\nWe reserve the right to determine, in our sole discretion, whether a particular action qualifies for Nexpil Points. After accumulating Nexpil Points, you will be automatically entered into a weekly drawing for a Gift based upon your Nexpil Point level (see the section titled “Drawings” below for more information). Please note that you may be required to provide additional information to Nexpil or a third party merchant in order to redeem certain Gifts, and processing fees may also be applicable to Gift redemption.\nWe will use reasonable efforts to ensure that your Nexpil Points are viewable via your Account within 7 days from accrual. You should contact us if it has been more than 7 days and the Nexpil Points have not been applied to your Account. We may also, at our discretion, delay any Gift redemption or Nexpil Point accrual in order to validate or verify your actions via the Service.\nYou acknowledge and agree that:\n·       In order to accrue Nexpil Points you must be at least 18 years of age. You may also be required to be a registered user with an Account in good standing;\n·       Gifts are not transferable and can only be used in accordance with any terms and conditions made available via the Service;\n·       We are not responsible or liable for any unredeemed, unused or lost Gifts or Nexpil Points;\n·       Gifts are not redeemable for any sum of money or monetary value;\n·       Nexpil Points in your account may expire 12 months after such points are accrued via the Service. In addition, all unredeemed Nexpil Points may expire if no qualifying action has been made from your Nexpil account for 12 consecutive months. We reserve the right to issue points that may have a shorter expiration date, and to remove Nexpil Points from your Account to correct errors. You may not be provided with notice of expiration, forfeiture or removal of points, and you are not entitled to any compensation for any such event.\nNexpil reserves the right to modify or discontinue the Gift Program, or any Gifts and Nexpil Points related thereto. If you have any questions, please contact us.\n\nDRAWINGS\n\nAs noted above, a user can become eligible to be entered into Drawings for the chance to receive Gifts via the Service based upon the number of Nexpil Points such user earns in connection with his or her use of the Service. The following terms and conditions apply to such Drawings:\n·       NO ENTRY FEE. NO PURCHASE NECESSARY TO ENTER OR WIN. VOID WHERE PROHIBITED.\n·       Drawings are sponsored by Nexpil.\n·       Drawings are held on or around the dates specified at support.nexpil.com for each Nexpil Point level.\n·       Drawings are open to legal residents of the U.S. who have accessed or used the Service in the seven (7) day period prior to the applicable Drawing. Employees of Nexpil and its affiliates and agencies are not eligible to participate in Drawings.\n·       Nexpil users who accrue a threshold level of Nexpil Points will be automatically entered into a Drawing each week. Each week, Nexpil will hold up to ten (10) drawings, with eligibility for Drawing based upon a Nexpil Point range. Users will be entered into the weekly Drawing that is associated with the Nexpil Point total in the user’s Account each week. Each user may only win one (1) Drawing per Nexpil Point range. More information on Nexpil Point levels associated with each Drawing is accessible at support.nexpil.com.\n·       Each Drawing will be conducted either by independent persons or a computer program that automatically chooses the winners from all eligible users, and the random selections are final and binding.\n·       Winners will be notified via the Service or via email within one (1) week of the Drawing date.\n·       The number, type and approximate retail value of Gifts associated with each Drawing is accessible on the information details screen associated with each Gift within the Service or at support.nexpil.com.\n·       The odds of winning a Gift depend on the eligible number of users for each Drawing.\n·       No cash or substitution of Gifts is permitted, except at the sole discretion of Nexpil for a prize of equal or greater value.\n·       Winners are solely responsible for any and all federal, state and local taxes, if any, that apply to Gifts.\n·       If a selected winner cannot be contacted, is ineligible or fails to claim a Gift within seven (7) days of the Drawing date, the Gift may be forfeited and an alternate winner selected from the remaining eligible users.\n·       Nexpil reserves the right to disqualify any user or winner as determined by Nexpil, in its sole discretion.\n·       Drawings are subject to these Terms and all applicable, federal, state, provincial and local laws and regulations apply.\n\nMORE ON Nexpil POINTS\n\nNexpil Points are digital items only, and regardless of the terminology used, have no cash value and may never be redeemed for “real world” money. Your right to use any Nexpil Points that you obtain is limited to a non-exclusive, non-transferable, non-sublicensable, revocable right to use such Nexpil Points solely in connection with our Gift Program (as described above). Except for the limited rights described herein, you have no property interest or right or title in or to any such Nexpil Points, which remain the exclusive property of Nexpil. The scope, variety and type of Nexpil Points that you may obtain can change at any time. Nexpil has the absolute right to manage, regulate, control, modify or eliminate such Nexpil Points as it sees fit in its sole discretion, and Nexpil will have no liability to you or any third party for the exercise of such rights.\nExcept where explicitly authorized within the Service, (i) transfers of Nexpil Points are strictly prohibited; (ii) outside of the Service, you may not buy or sell any Nexpil Points for “real world” money or otherwise exchange items for value; and (iii) Nexpil does not recognize any such purported transfers of Nexpil Points, nor the purported sale, gift or trade in the “real world” of anything that appears in the Service. Any attempt to do any of the foregoing is a violation of these Terms and will result in an automatic termination of your rights to use the Nexpil Points and may result in termination of your Account, a lifetime ban from the Service and/or possible legal action. All Nexpil Points are forfeited if your Account is terminated or suspended for any reason, in Nexpil’s sole and absolute discretion, or if Nexpil discontinues providing the Service.\n\nPROMOTIONS\n\nIn addition to the Gift Program, Nexpil may decide to sponsor and run sweepstakes, contests and similar promotions (collectively, “Promotions”) through the Service. You should carefully review any additional terms and conditions governing each Nexpil Promotion (“Official Rules”). To the extent that the terms and conditions of such Official Rules conflict with these Terms for a Promotion only, the Official Rules will govern for the Promotion in question. In addition, third parties may sponsor and run Promotions through the Service (“Third Party Promotions”). Your participation in each Third Party Promotion is governed by terms and conditions provided by the third party sponsoring and running such Third Party Promotion, and you agree that Nexpil is not responsible for any Third Party Promotions, and disclaims any and all liability relating thereto. Your participation in Third Party Promotions is at your own risk.\n\nTHIRD-PARTY CONTENT\n\nVia the Service, we may provide you with access to third-party content, such as information regarding interactions with Medications and Supplements, news articles, and other content. NEXPIL HEREBY DISCLAIMS ANY LIABILITY WITH RESPECT TO ANY SUCH THIRD PARTY-CONTENT. WITHOUT LIMITING THE FOREGOING, YOU UNDERSTAND AND AGREE THAT SUCH THIRD PARTY-CONTENT IS FOR INFORMATIONAL PURPOSES ONLY. YOUR PERSONAL HEALTHCARE-RELATED SITUATION IS PERSONAL TO YOU, AND THE THIRD-PARTY CONTENT MAY NOT BE APPROPRIATE OR RELEVANT FOR YOUR PERSONAL SITUATION. AS STATED ABOVE, THE SERVICE IS NOT INTENDED TO PROVIDE HEALTH OR MEDICAL ADVICE, AND BEFORE MAKING ANY DECISIONS THAT MAY AFFECT YOUR HEALTH, YOU SHOULD CONSULT A HEALTHCARE PROFESSIONAL.\n\nUNAUTHORIZED ACTIVITIES\n\nOur Service may be used and accessed for lawful purposes only. You agree that you will not do any of the following while using or accessing the Service: (i) attempt to access or search the Service or download Content from the Service through the use of any engine, software, tool, agent, device or mechanism (including spiders, robots, crawlers, data mining tools or the like) other than the software and/or search agents provided by us or other generally available third party web browsers; (ii) access, tamper with, or use non-public areas of the Service, our computer systems, or the technical delivery systems of our providers; (iii) gather and use information, such as other users’ names, real names, email addresses, available through the Service to transmit any unsolicited advertising, junk mail, spam or other form of solicitation; (iv) use the Service for any commercial purpose or for the benefit of any third party or in any manner not by these Terms; (v) violate any applicable law or regulation; or (vi) encourage or enable any other individual to do any of the foregoing. We reserve the right to investigate and prosecute violations of any of the above and/or involve and cooperate with law enforcement authorities in prosecuting users who violate these Terms.\n\nINDEMNITY\n\nYou agree to indemnify and hold us harmless from and against any and all costs, damages, liabilities, and expenses (including attorneys' fees) we incur in relation to, arising from, or for the purpose of avoiding, any claim or demand from a third party that your use of the Service or the use of the Service by any person using your Account violates any applicable law or regulation, or the rights of any third party.\n\nLINKS TO THIRD PARTY SITES\n\nThe Service may include links to other sites and services that are not operated by us. We are providing these links to you only as a convenience and are not responsible for the content or links displayed on such sites. You are responsible for and assume all risk arising from your use or reliance of any third party sites.\n\nOWNERSHIP\n\nOur App and Service is protected by copyright, trademark, and other laws of the United States and foreign countries. Except as expressly provided in these Terms, we (or our licensors) exclusively own all right, title and interest in and to the App and the Service, including all associated intellectual property rights. You may not remove, alter or obscure any copyright, trademark, service mark or other proprietary rights notices incorporated in or accompanying the App or the Service, including in any Content. You acknowledge and agree that any feedback, comments or suggestions you may provide regarding the App or the Service (“Feedback”) will be the sole and exclusive property of Nexpil and you hereby irrevocably assign to us all of your right, title and interest in and to all Feedback.\n\nTERMINATION\n\nIf you breach any of the terms of these Terms, we have the right to suspend or disable your access to or use of the App and/or Service. You may cancel your use of the App and/or Service by contacting us.\n\nDISCLAIMER\n\nYou understand and agree that the App and the Service are provided to you “AS IS” and on an “AS AVAILABLE” basis. Without limiting the foregoing, WE EXPLICITLY DISCLAIM ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT, AND ANY WARRANTIES ARISING OUT OF COURSE OF DEALING OR USAGE OF TRADE. We make no warranty that the App or the Service will meet your requirements or be available on an uninterrupted, secure, or error-free basis.\n\nLIMITATION OF LIABILITY\n\nOUR TOTAL LIABILITY TO YOU FROM ALL CAUSES OF ACTION AND UNDER ALL THEORIES OF LIABILITY WILL BE LIMITED TO THE AMOUNT YOU PAID FOR USE OF THE APP AND SERVICE, IF YOU HAVE MADE ANY PAYMENTS TO NEXPIL OR $50, IF YOU HAVE NOT MADE ANY PAYMENTS TO NEXPIL, AS APPLICABLE. WE WILL NOT BE LIABLE TO YOU FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL OR PUNITIVE DAMAGES, INCLUDING WITHOUT LIMITATION, LOSS OF PROFITS, DATA, USE, GOODWILL, OR OTHER INTANGIBLE LOSSES, RESULTING FROM (i) YOUR ACCESS TO OR USE OF OR INABILITY TO ACCESS OR USE THE APP AND/OR SERVICE; (ii) ANY CONDUCT OR CONTENT OF ANY THIRD PARTY ON THE SERVICE; (iii) ANY CONTENT OBTAINED FROM THE SERVICE; AND (iv) UNAUTHORIZED ACCESS, USE OR ALTERATION OF YOUR TRANSMISSIONS OR CONTENT, WHETHER BASED ON WARRANTY, CONTRACT, TORT (INCLUDING NEGLIGENCE) OR ANY OTHER LEGAL THEORY, WHETHER OR NOT WE HAVE BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGE, AND EVEN IF A REMEDY SET FORTH HEREIN IS FOUND TO HAVE FAILED OF ITS ESSENTIAL PURPOSE.\n\nEXCLUSIONS\n\nSome jurisdictions do not allow the exclusion of certain warranties or the exclusion or limitation of liability for consequential or incidental damages, so the limitations above may not apply to you.\n\nGENERAL\n\nThese Terms are governed by the laws of the State of California, without regard to any conflict of laws rules or principles. Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions of these Terms will remain in effect. These Terms constitute the entire agreement between us regarding our Service, and supersede and replace any prior agreements we might have between us regarding the Service. If we make any material changes to these Terms, we will notify you of such changes by posting them on Nexpil or by sending you an email or other notification or message (including push notifications and in-app news notices) and we will indicate when such changes will become effective. By continuing to access or use our Service after those revisions become effective, you agree to be bound by the revised Terms.\n\nQUESTIONS & CONTACT INFORMATION\n\nPlease contact us if you have any questions about our Terms.\nEffective: December 15, 2014\nThe following end-user license agreement relates to the Nexpil platform, which is integrated into Nexpil, and which provides information on drug interactions. By accepting our Terms of Use, you are also agreeing to the Nexpil Product End-User License Agreement as the end user.\n\nNEXPIL INTEGRATED TM PRODUCT END-USER LICENSE AGREEMENT\n\nThis product utilizes the Nexpil platform (the “Nexpil Product), which contains information provided by Lexi-Comp, Inc. (D.B.A. Nexpil) (“Nexpil”) and/or Cerner Nexpil, Inc. (“Nexpil”). The Nexpil Product is a product licensed to you by Nexpil. The Nexpil Product and the “Client System” are separate products provided by separate entities. The Nexpil Product is intended for use in the United States.\nYour use of this product acknowledges acceptance of these restrictions, disclaimers, and limitations. You expressly acknowledge and agree that neither Nexpil nor Nexpil is responsible for the results of your decisions resulting from the use of the Nexpil Product, including, but not limited to, your choosing to seek or not to seek professional medical care, or from choosing or not choosing specific treatment based on the Nexpil Product.\nEvery effort has been made to ensure that the information provided in the Nexpil Product is accurate, up-to-date, and complete, but no guarantee is made to that effect. In addition, the drug information contained herein may be time sensitive. The information contained in the Nexpil Product has been compiled for use by healthcare practitioners and individuals in the United States. Providers do not warrant that uses outside of the United States are appropriate.\nThe Nexpil Product does not endorse drugs, diagnose patients, or recommend therapy. The Nexpil Product is an informational resource designed to assist licensed healthcare practitioners in caring for their patients and provide consumers with drug specific information. Healthcare practitioners should use their professional judgment in using the information provided. The Nexpil Product is not a substitute for the care provided by licensed healthcare practitioners and consumers are urged to consult with their healthcare practitioner in all instances. The absence of a warning for a given drug or drug combination in no way should be construed to indicate that the drug or drug combination is safe, effective or appropriate for any given patient.\nNexpil does not assume any responsibility for any aspect of healthcare administered or not administered with the aid of information the Nexpil Product provides.\nThe Nexpil Product is copyright 2012 Lexi-Comp, Inc. and/or Cerner Nexpil, Inc. All rights reserved. Client System as integrated with the Nexpil Product is is covered by U.S. Patent No. 5,833,599 and U.S. Patent No. 6,317,719.\n\nDISCLAIMER OF WARRANTIES\n\nTHE END-USER ACKNOWLEDGES THAT THE NEXPIL PRODUCT IS PROVIDED ON AN \"AS IS\" BASIS. EXCEPT FOR WARRANTIES WHICH MAY NOT BE DISCLAIMED AS A MATTER OF LAW, NEXPIL, NEXPIL AND ITS AFFILIATES MAKES NO REPRESENTATIONS OR WARRANTIES WHATSOEVER, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO REPRESENTATIONS OR WARRANTIES REGARDING THE ACCURACY OR NATURE OF THE CONTENT OF THE NEXPIL PRODUCT, WARRANTIES OF TITLE, NONINFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.\nIN ADDITION, WITHOUT LIMITING THE FOREGOING, THE NEXPIL PRODUCT HAS BEEN DESIGNED FOR USE IN THE UNITED STATES ONLY AND COVERS THE DRUG PRODUCTS USED IN PRACTICE IN THE UNITED STATES. NEITHER NEXPIL NOR NEXPIL PROVIDE ANY CLINICAL INFORMATION NOR DO NEXPIL NOR NEXPIL CHECK FOR DRUGS NOT AVAILABLE FOR SALE IN THE UNITED STATES AND CLINICAL PRACTICE PATTERNS OUTSIDE THE UNITED STATES MAY DIFFER SUBSTANTIALLY FROM INFORMATION SUPPLIED BY THE NEXPIL PRODUCT. NEITHER NEXPIL NOR NEXPIL WARRANT THAT USES OUTSIDE THE UNITED STATES ARE APPROPRIATE.\nThe End-User acknowledges that updates to the Nexpil Product are at the sole discretion of Nexpil. Nexpil makes no representations or warranties whatsoever, express or implied, with respect to the compatibility of the Nexpil Product, or future releases thereof, with any computer hardware or software, nor does Nexpil represent or warrant the continuity of the features or the facilities provided by or through the Nexpil Product as between various releases thereof.\nAny warranties expressly provided herein do not apply if: (i) the End-User alters, mishandles or improperly uses, stores or installs all, or any part, of the Nexpil Product, (ii) the End-User uses, stores or installs the Nexpil Product on a computer system which fails to meet the specifications provided by Nexpil, or (iii) the breach of warranty arises out of or in connection with acts or omissions of persons other than Nexpil.\n\nASSUMPTION OF RISK, DISCLAIMER OF LIABILITY, INDEMNITY\n\nTHE END-USER ASSUMES ALL RISK FOR SELECTION AND USE OF THE NEXPIL PRODUCT AND CONTENT PROVIDED THEREON. NEITHER NEXPIL NOR NEXPIL SHALL NOT BE RESPONSIBLE FOR ANY ERRORS, MISSTATEMENTS, INACCURACIES OR OMISSIONS REGARDING CONTENT DELIVERED THROUGH THE NEXPIL PRODUCT OR ANY DELAYS IN OR INTERRUPTIONS OF SUCH DELIVERY.\nTHE END-USER ACKNOWLEDGES THAT NEXPIL AND/OR NEXPIL: (A) HAS NO CONTROL OF OR RESPONSIBILITY FOR THE END-USER’S USE OF THE NEXPIL PRODUCT OR CONTENT PROVIDED THEREON, (B) HAS NO KNOWLEDGE OF THE SPECIFIC OR UNIQUE CIRCUMSTANCES UNDER WHICH THE NEXPIL PRODUCT OR CONTENT PROVIDED THEREON MAY BE USED BY THE END-USER, (C) UNDERTAKES NO OBLIGATION TO SUPPLEMENT OR UPDATE CONTENT OF THE NEXPIL PRODUCT, AND (D) HAS NO LIABILITY TO ANY PERSON FOR ANY DATA OR INFORMATION INPUT ON THE NEXPIL PRODUCT BY PERSONS OTHER THAN NEXPIL OR NEXPIL RESPECTIVELY.\nNEXPIL, NEXPIL AND THEIR RESPECTIVE AFFILIATES SHALL NOT BE LIABLE TO ANY PERSON (INCLUDING BUT NOT LIMITED TO THE END-USER AND PERSONS TREATED BY OR ON BEHALF OF THE END-USER) FOR, AND THE END-USER AGREES TO INDEMNIFY AND HOLD NEXPIL AND NEXPIL HARMLESS FROM ANY CLAIMS, LAWSUITS, PROCEEDINGS, COSTS, ATTORNEYS’ FEES, DAMAGES OR OTHER LOSSES (COLLECTIVELY, \"LOSSES\") ARISING OUT OF OR RELATING TO (A) THE END-USER'S USE OF THE NEXPIL PRODUCT OR CONTENT PROVIDED THEREON OR ANY EQUIPMENT FURNISHED IN CONNECTION THEREWITH AND (B) ANY DATA OR INFORMATION INPUT ON THE NEXPIL PRODUCT BY END-USER, IN ALL CASES INCLUDING BUT NOT LIMITED TO LOSSES FOR TORT, PERSONAL INJURY, MEDICAL MALPRACTICE OR PRODUCT LIABILITY. FURTHER, WITHOUT LIMITING THE FOREGOING, IN NO EVENT SHALL NEXPIL, NEXPIL AND THEIR RESPECTIVE AFFILIATES BE LIABLE FOR ANY SPECIAL, INCIDENTAL, CONSEQUENTIAL, OR INDIRECT DAMAGES, INCLUDING DAMAGES FOR LOSS OF PROFITS, LOSS OF BUSINESS, OR DOWN TIME, EVEN IF NEXPIL OR NEXPIL HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. THE INFORMATION CONTAINED WITHIN THE NEXPIL PRODUCT IS INTENDED FOR USE ONLY AS AN INFORMATIONAL TOOL AND END-USERS ARE URGED TO CONSULT WITH A PHYSICIAN OR OTHER HEALTHCARE PROFESSIONAL REGARDING THEIR SPECIFIC SITUATION FOR DIAGNOSIS OR BY PHYSICIANS AND PROFESSIONALS WHO SHOULD RELY ON THEIR CLINICAL DISCRETION AND JUDGMENT IN DIAGNOSIS AND TREATMENT. AS BETWEEN THE END-USER AND NEXPIL OR NEXPIL, THE END-USER HEREBY ASSUMES FULL RESPONSIBILITY FOR INSURING THE APPROPRIATENESS OF USING AND RELYING UPON THE INFORMATION IN VIEW OF ALL ATTENDANT CIRCUMSTANCES, INDICATIONS, AND CONTRAINDICATIONS.\n\nLIABILITY OF NEXPIL TO THE END-USER\n\nUnder no circumstances shall Nexpil, Nexpil, and their respective affiliates be liable to the End-User or any other person for any direct, indirect, exemplary, special or consequential damages arising out of or relating to the End-User's use of or inability to use the Nexpil Product or the content of the Nexpil Product provided thereon or any equipment furnished in connection therewith. Nexpil's and Nexpil’s total maximum cumulative liability hereunder in connection with this Agreement, whether arising under contract or otherwise, are limited to the fees received by Nexpil under this Agreement specifically relating to the End-User's use of the Nexpil Product or product which is the subject of the claim.","Your Privacy when Using Nexpil digital health Products and Services\n\nNexpil’s Privacy Policy explains how we process your Personal data when you use our Products and Services. In addition, the following applies to your use of Nexpil health Products and Services (\"Product(s) and Service(s)\")\n\nThe Products and Services are composed of various software applications (including mobile applications, web Applications, Product software), cloud based Services and “smart” Products that gather, store and process data to provide you insights and Services to help you lead a healthier life.\n\nWhat information do we collect and when?\n\nWhen you are using Nexpil digital health Products and Services, we may need to collect data to provide you the Service as described in the Nexpil’s Privacy Policy. As transparency and easy access are key factors for us, we have created this list of pictograms so that you can easily identify what Personal data is processed in the following scenarios.","The data contained in the Nexpil mobile application, including the text, images, and graphics, are for informational purposes only. Use of the mobile application is not intended to be a substitute for professional medical judgment and you should promptly contact your own health care provider regarding any medical conditions or medical questions that you have. THE MOBILE APPLICATION DOES NOT OFFER MEDICAL ADVICE, AND NOTHING CONTAINED IN THE CONTENT IS INTENDED TO CONSTITUTE PROFESSIONAL ADVICE FOR MEDICAL DIAGNOSIS OR TREATMENT. The practice of medicine is a complex process that involves the synthesis of information from a multiplicity of sources. The information contained in the mobile application delivers similar information to that of a textbook or other health resource. Nexpil, Inc. d/b/a Nexpil (\"Company\") accepts no responsibility for the correctness of any diagnosis based in whole or in part upon the use of this mobile application. The data represent the current view of the individual author and do not necessarily represent the view of the Company or other contributing institutions, nor does inclusion on the site of advertisements for specific products or manufacturers indicate endorsement by the Company's contributing institutions or authors.\nAlthough great care has been taken in compiling and checking the information given to ensure accuracy, the Company, the authors, their employers, the sponsors, and their servants or agents shall not be responsible or in any way liable for any errors, omissions, or inaccuracies, whether arising from negligence or otherwise, or for any consequences arising therefrom.\nDISCLAIMER OF WARRANTIES. THIS MOBILE APPLICATION AND ITS CONTENT ARE PROVIDED \"AS IS.\" THE COMPANY MAKES NO REPRESENTATIONS OR ENDORSEMENT ABOUT THE SUITABILITY FOR ANY PURPOSE OF PRODUCTS AND SERVICES AVAILABLE THROUGH THIS MOBILE APPLICATION. WE DO NOT GUARANTEE THE TIMELINESS, VALIDITY, COMPLETENESS, OR ACCURACY OF THE CONTENT. WE DISCLAIM ALL WARRANTIES AND CONDITIONS, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT, WITH REGARD TO THE CONTENT, PRODUCTS, SERVICES, AND ALL OTHER INFORMATION CONTAINED ON AND/OR MADE AVAILABLE THROUGH THIS MOBILE APPLICATION, INCLUDING BUT NOT LIMITED TO THE AVAILABILITY OF THIS MOBILE APPLICATION. ALTHOUGH WE MAY UPDATE THE CONTENT ON THIS MOBILE APPLICATION FROM TIME TO TIME, PLEASE NOTE THAT MEDICAL INFORMATION CHANGES RAPIDLY. THEREFORE, SOME OF THE INFORMATION MAY BE OUT OF DATE AND/OR MAY CONTAIN ERRORS. BECAUSE SOME JURISDICTIONS DO NOT PERMIT THE EXCLUSION OF CERTAIN WARRANTIES, THESE EXCLUSIONS MAY NOT APPLY TO YOU.\nThe Nexpil Mobile Application may contain graphic health- or medical-related materials. If you find these materials offensive, you may not want to use the Mobile Application."]


class ProfileViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    ProfileModelViewDelegate,
    ProfileConditionDetailModalViewDelegate,
    ProfileAddConditionModalViewDelegate,
    ProfileDoctorDetailModalViewDelegate,
    ProfilePharmacyDetailModalViewDelegate,
    ProfileCommunityDetailModalViewDelegate,
    ProfileAddCommunityModalViewDelegate,
    ProfileScheduleDetailModalViewDelegate,
    ProfileAddAppModalViewDelegate,
    ProfilePersonDetailModalViewDelegate,
    ProfileAddCardModalViewDelegate,
    ProfileSettingModalViewDelegate,
    SettingTermModalViewDelegate,
    SettingSnoozeModalViewDelegate,
    SettingPasswordModalViewDelegate,
    SettingEmailModalViewDelegate,
    ProfileAddPharmacyModalViewDelegate,
    HealthConditionModelViewDelegate
{

 

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblMemberSince: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var m_vwRadialRight: UIView!
    @IBOutlet weak var m_vwRadialLeft: UIView!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var tableList: UITableView!
    @IBOutlet weak var settingFAB: FAButton!
    
    var window = UIWindow()
    var bgView = UIView()
    var visualEffectView:UIVisualEffectView = UIVisualEffectView()
    var selectIndex: Int = 0
    
    var popModalView: ProfileModelView = ProfileModelView()
    var popConditionDetailView: ProfileConditionDetailModalView = ProfileConditionDetailModalView()
    var popAddConditionView: ProfileAddConditionModalView = ProfileAddConditionModalView()
    
    var popAddPharmacyView: ProfileAddPharmacyModalView = ProfileAddPharmacyModalView()
    
    var popDoctorDetailView: ProfileDoctorDetailModalView = ProfileDoctorDetailModalView()
    var popPharmacyDetailView: ProfilePharmacyDetailModalView = ProfilePharmacyDetailModalView()
    var popCommunityDetailView: ProfileCommunityDetailModalView = ProfileCommunityDetailModalView()
    var popAddCommunityView: ProfileAddCommunityModalView = ProfileAddCommunityModalView()
    var popScheduleDetailView: ProfileScheduleModalView = ProfileScheduleModalView()
    var popAddAppView: ProfileAddAppModalView = ProfileAddAppModalView()
    var popPersonDetailView: ProfilePersonDetailModalView = ProfilePersonDetailModalView()
    var popVerifyCardView: ProfileAddCardModalView = ProfileAddCardModalView()
    var popSettingView: ProfileSettingModalView = ProfileSettingModalView()
    var popSettingTermView: SettingTermModalView = SettingTermModalView()
    var popSettingSnoozeView: SettingSnoozeModalView = SettingSnoozeModalView()
    var popSettingPasswordView: SettingPasswordModalView = SettingPasswordModalView()
    var popSettingEmailView: SettingEmailModelView = SettingEmailModelView()
    
    var popHealthConditionModelView: HealthConditionModelView = HealthConditionModelView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initMainView()
       // self.getSelfData()

        profileView.setPopItemViewStyle(radius: 15.0, title: PShadowType.large)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = m_vwRadialLeft.bounds
        gradientLayer.colors = NPColorScheme(rawValue: 2)!.gradient
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.cornerRadius = m_vwRadialLeft.frame.height / 2
        m_vwRadialLeft.layer.addSublayer(gradientLayer)
        
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.frame = m_vwRadialRight.bounds
        gradientLayer1.colors = NPColorScheme(rawValue: 2)!.gradient
        gradientLayer1.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer1.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer1.cornerRadius = m_vwRadialRight.frame.height / 2
        m_vwRadialRight.layer.addSublayer(gradientLayer1)
        
//        imageView.setPopItemViewStyle(title: PShadowType.small)
//        imageView.layer.cornerRadius = 30.0
        imageView.setPopItemViewStyle(radius: 30.0, title: .large)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.alpha = 0.0
        view.addSubview(visualEffectView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped(tapGestureRecognizer:)))
        profileView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func profileViewTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        visualEffectView.alpha = 0.96
        mTabView.isHidden = true
        settingFAB.isHidden = true
        self.addPersonDetailPopView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        m_vwRadialLeft.layer.cornerRadius = m_vwRadialLeft.frame.width / 2
        m_vwRadialRight.layer.cornerRadius = m_vwRadialRight.frame.width / 2
        imgProfile.layer.cornerRadius = imgProfile.frame.width / 2
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func initMainView() {
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.frame.width / 2

        lblMemberSince.font         = UIFont(name: "Montserrat", size: 19)!
        lblMemberSince.textColor    = UIColor.init(hex: "333333")
    }

    override func viewWillAppear(_ animated: Bool) {
        getSelfData()
        DataUtils.customActivityIndicatory(self.view, startAnimate: true)

        DataUtils.getCommunityUser { (success, users) in
            if success{
                arrayCommunity = users
                DataUtils.customActivityIndicatory(self.view, startAnimate: false)
            }
        }
        if let value = UserDefaults.standard.value(forKey: "reloadProfileItems") as? String{
            if value == "true"{
//                reloadModel()
                UserDefaults.standard.set("false", forKey: "reloadProfileItems")
            }
        }
     }
    func reloadModel(){
        self.popViewDismissal()
        visualEffectView.alpha = 0.96
        mTabView.isHidden = true
        settingFAB.isHidden = true
        self.addComonPopView(index: selectIndex)
        popModalView.resetMedicationList(type: selectIndex)
    }
    
    func getSelfData() {
        let preference = PreferenceHelper()
        
        if preference.getUserImage()! == ""
        {
            let image = UIImage(named: "Intersection 1")
            imgProfile.image = image
            imgProfile.contentMode = .scaleAspectFit
        }
        else
        {
            let url = URL(string: DataUtils.PROFILEURL + preference.getUserImage()!)
            imgProfile.kf.setImage(with: url)
            imgProfile.contentMode = .scaleAspectFit
        }
        
        let strCreatedAt = preference.getCreatedAt()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        //formatter.timeZone = TimeZone.autoupdatingCurrent
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MMMM d, yyyy"
        //formatter1.timeZone = TimeZone.current
        let date = formatter.date(from: strCreatedAt!)
        let strDate = formatter1.string(from: date!)
        
        lblMemberSince.text = preference.getFirstName()! + " " + preference.getLastName()!
        lblDate.text = "Member Since: " + strDate
    }
    
    func addPersonDetailPopView() {
        popPersonDetailView = Bundle.main.loadNibNamed("ProfilePersonDetailModalView", owner: self, options: nil)?.first as! ProfilePersonDetailModalView
        popPersonDetailView.delegate = self
        popPersonDetailView.frame = self.view.frame
        self.view.addSubview(popPersonDetailView)
    }
    
    func addComonPopView(index value: Int) {
//        if value == 1 {
//            popHealthConditionModelView = Bundle.main.loadNibNamed("HealthConditionModelView", owner: self, options: nil)?.first as! HealthConditionModelView
//            popHealthConditionModelView.delegate = self
//            popHealthConditionModelView.frame = self.view.frame
//            self.view.addSubview(popHealthConditionModelView)
//        } else {
            popModalView = Bundle.main.loadNibNamed("ProfileModelView", owner: self, options: nil)?.first as! ProfileModelView
            popModalView.delegate = self
            popModalView.frame = self.view.frame
            popModalView.titleUL.text = menus[value]
            //        popModalView.addUB.setTitle("Add " + menus[value], for: .normal)
            self.view.addSubview(popModalView)
//        }
    }
    
    func addConditionDetailPopView(index value: Int) {
        popConditionDetailView = Bundle.main.loadNibNamed("ProfileConditionDetailModalView", owner: self, options: nil)?.first as! ProfileConditionDetailModalView
        popConditionDetailView.delegate = self
        popConditionDetailView.frame = self.view.frame
        popConditionDetailView.titleUL.text = arrayCondition[value].value(forKey: "title") as? String

        self.view.addSubview(popConditionDetailView)
    }

    func addAddConditionPopView() {
        popAddConditionView = Bundle.main.loadNibNamed("ProfileAddConditionModalView", owner: self, options: nil)?.first as! ProfileAddConditionModalView
        popAddConditionView.delegate = self
        popAddConditionView.frame = self.view.frame
        self.view.addSubview(popAddConditionView)
    }
    
    func addAddPharmacyPopView(){
        popAddPharmacyView = Bundle.main.loadNibNamed("ProfileAddPharmacyModalView", owner: self, options: nil)?.first as! ProfileAddPharmacyModalView
        popAddPharmacyView.delegate = self
        popAddPharmacyView.frame = self.view.frame
        
        self.view.addSubview(popAddPharmacyView)
    }
    func addDoctorDetailPopView(index value: Int) {
        popDoctorDetailView = Bundle.main.loadNibNamed("ProfileDoctorDetailModalView", owner: self, options: nil)?.first as! ProfileDoctorDetailModalView
        popDoctorDetailView.delegate = self
        popDoctorDetailView.frame = self.view.frame
        popDoctorDetailView.titleUL.text = arrayDoctor[value].value(forKey: "name") as? String
        popDoctorDetailView.nameTF.text = arrayDoctor[value].value(forKey: "name") as? String
        popDoctorDetailView.phoneTF.text = arrayDoctor[value].value(forKey: "phone") as? String
        popDoctorDetailView.avatarUIV.image = UIImage(named: (arrayDoctor[value].value(forKey: "image") as? String)!)
//        popDoctorDetailView.addressUL.text = arrayDoctor[value].value(forKey: "name") as? String
        
        self.view.addSubview(popDoctorDetailView)
    }
    
    func addPharmacyDetailPopView(index value: Int) {
        
           let mapItem =  arrayPharmacy[value]
            popPharmacyDetailView = Bundle.main.loadNibNamed("ProfilePharmacyDetailModalView", owner: self, options: nil)?.first as! ProfilePharmacyDetailModalView
            popPharmacyDetailView.delegate = self
            popPharmacyDetailView.frame = self.view.frame
            self.view.addSubview(popPharmacyDetailView)
            let artwork = Artwork(title: mapItem.brand,
                                  locationName: mapItem.address,
                                  discipline: "Pharmacies",
                                  coordinate: CLLocationCoordinate2D(latitude: Double(mapItem.latitude)!, longitude: Double(mapItem.longitude)!))
            popPharmacyDetailView.mapView.addAnnotation(artwork)
            let center = CLLocationCoordinate2D(latitude: Double(mapItem.latitude)! , longitude: Double(mapItem.longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            popPharmacyDetailView.mapView.setRegion(region, animated: false)
            popPharmacyDetailView.addressLine.text = mapItem.address
            popPharmacyDetailView.phoneNumber.text = mapItem.phone_number
            popPharmacyDetailView.title.text = mapItem.brand
    }
    
    func addCommunityDetailPopView(index value: Int) {
        popCommunityDetailView = Bundle.main.loadNibNamed("ProfileCommunityDetailModalView", owner: self, options: nil)?.first as! ProfileCommunityDetailModalView
        popCommunityDetailView.delegate = self
        popCommunityDetailView.frame = self.view.frame
        popCommunityDetailView.titleUL.text = arrayCommunity[value].firstname + arrayCommunity[value].lastname
        let url = URL(string: DataUtils.PROFILEURL + arrayCommunity[value].userimage)
        popCommunityDetailView.avatarUIV.kf.setImage(with: url)
        imgProfile.contentMode = .scaleAspectFit
        self.view.addSubview(popCommunityDetailView)
    }
    
    func addAddCommunityPopView() {
        popAddCommunityView = Bundle.main.loadNibNamed("ProfileAddCommunityModalView", owner: self, options: nil)?.first as! ProfileAddCommunityModalView
        popAddCommunityView.delegate = self
        popAddCommunityView.frame = self.view.frame
        
        self.view.addSubview(popAddCommunityView)
    }
    
    func addScheduleDetailPopView(index value: Int) {
//        popScheduleDetailView = Bundle.main.loadNibNamed("ProfileScheduleDetailModalView", owner: self, options: nil)?.first as! ProfileScheduleDetailModalView
//        popScheduleDetailView.delegate = self
//        popScheduleDetailView.frame = self.view.frame
//        popScheduleDetailView.titleUL.text = arraySchedule[value].value(forKey: "title") as? String
        popScheduleDetailView = Bundle.main.loadNibNamed("ProfileScheduleModalView", owner: self, options: nil)?.first as! ProfileScheduleModalView
        popScheduleDetailView.delegate = self
        popScheduleDetailView.type = value
        popScheduleDetailView.data = arraySchedule[value]
        popScheduleDetailView.frame = self.view.frame

        self.view.addSubview(popScheduleDetailView)
    }
    
    func addAddAppPopView() {
        popAddAppView = Bundle.main.loadNibNamed("ProfileAddAppModalView", owner: self, options: nil)?.first as! ProfileAddAppModalView
        popAddAppView.delegate = self
        popAddAppView.frame = self.view.frame
        
        self.view.addSubview(popAddAppView)
    }
    
    func addVerifyCardPopView() {
        popVerifyCardView = Bundle.main.loadNibNamed("ProfileAddCardModalView", owner: self, options: nil)?.first as! ProfileAddCardModalView
        popVerifyCardView.delegate = self
        popVerifyCardView.frame = self.view.frame
        
        self.view.addSubview(popVerifyCardView)
    }
    
    func addSettingPopView() {
        popSettingView = Bundle.main.loadNibNamed("ProfileSettingModalView", owner: self, options: nil)?.first as! ProfileSettingModalView
        popSettingView.delegate = self
        popSettingView.frame = self.view.frame
        
        self.view.addSubview(popSettingView)
    }
    
    func addSettingTermPopView() {
        popSettingTermView = Bundle.main.loadNibNamed("SettingTermModalView", owner: self, options: nil)?.first as! SettingTermModalView
        popSettingTermView.delegate = self
        popSettingTermView.frame = self.view.frame
        
        self.view.addSubview(popSettingTermView)
    }
    
    func addSettingSnoozePopView(_ snooze: Int) {
        popSettingSnoozeView = Bundle.main.loadNibNamed("SettingSnoozeModalView", owner: self, options: nil)?.first as! SettingSnoozeModalView
        popSettingSnoozeView.delegate = self
        popSettingSnoozeView.frame = self.view.frame
        popSettingSnoozeView.snooze = snooze
        
        self.view.addSubview(popSettingSnoozeView)
    }
    
    func addSettingPasswordPopView() {
        popSettingPasswordView = Bundle.main.loadNibNamed("SettingPasswordModalView", owner: self, options: nil)?.first as! SettingPasswordModalView
        popSettingPasswordView.delegate = self
        popSettingPasswordView.frame = self.view.frame
        
        self.view.addSubview(popSettingPasswordView)
    }
    
    func addSettingEmailPopView() {
        popSettingEmailView = Bundle.main.loadNibNamed("SettingEmailModalView", owner: self, options: nil)?.first as! SettingEmailModelView
        popSettingEmailView.delegate = self
        popSettingEmailView.frame = self.view.frame
        
        self.view.addSubview(popSettingEmailView)
    }
    
    // table view datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMenuTableViewCell", for: indexPath) as? ProfileMenuTableViewCell
        cell?.menuname.text = menus[indexPath.row]
        cell?.backgroundview.setPopItemViewStyle()

        if menus[indexPath.row] == ""
        {
            cell?.backgroundview.backgroundColor = UIColor.init(hex: "f7f7fa")
            cell?.backgroundview.isHidden = true
        }
        else {
            cell?.backgroundview.backgroundColor = UIColor.white
            cell?.backgroundview.isHidden = false
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if(indexPath.row != 3)
//        {
//             self.addComonPopView(index: indexPath.row)
//        }
        
//        if indexPath.row == 1 {
//            popHealthConditionModelView = Bundle.main.loadNibNamed("HealthConditionModelView", owner: self, options: nil)?.first as! HealthConditionModelView
//            popHealthConditionModelView.delegate = self
//            popHealthConditionModelView.frame = self.view.frame
//            self.view.addSubview(popHealthConditionModelView)
//        } else {
//            self.addComonPopView(index: indexPath.row)
//            popModalView.delegate = self
//            popModalView.resetMedicationList(type: indexPath.row)
//        }
        if indexPath.row == 0 { // Medications
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileMedicationsViewController") as! ProfileMedicationsViewController
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        } else {
            selectIndex = indexPath.row
            visualEffectView.alpha = 0.96
            mTabView.isHidden = true
            settingFAB.isHidden = true
            if indexPath.row != 1 {
                self.addComonPopView(index: indexPath.row)
            }
            popModalView.delegate = self
            popModalView.resetMedicationList(type: indexPath.row)
        }
    }
    
    @IBAction func tapBtnSetting(_ sender: Any) {
//        let settingsViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
//        self.present(settingsViewController, animated: true, completion: nil)
        visualEffectView.alpha = 0.96
        mTabView.isHidden = true
        settingFAB.isHidden = true
        self.addSettingPopView()
    }
    
    // Mark: ProfileConditionDetailModalViewDelegate
    func popConditionDetailViewDismissal() {
        self.popConditionDetailView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }

    // Mark: PopModalViewDelegate
    func popViewDismissal() {
        self.popModalView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    func healConditionModelViewDismiss() {
        self.popHealthConditionModelView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    func addMedication() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDrugNavigationVC") as! UINavigationController        
        UserDefaults.standard.set("true", forKey: "reloadProfileItems")
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false, completion: nil)
    }
    
    func popViewAddBtnClick() {
        switch selectIndex {
        case 0:
            do {
                self.popModalView.removeFromSuperview()
                self.addMedication()
            }
        case 1:
            do {
                self.popModalView.removeFromSuperview()
                self.addAddConditionPopView()
            }
            break
        case 2:
            do {
                self.popViewDismissal()
            }
            break
        case 3:
            do {
                
            }
            break
        case 4:
            do {
                self.popModalView.removeFromSuperview()
                self.addAddConditionPopView()
            }
            break
        case 5:
            do {
                self.popModalView.removeFromSuperview()
                self.addAddCommunityPopView()
            }
            break
        case 7:
            do {
                self.popModalView.removeFromSuperview()
                self.addAddAppPopView()
            }
            break
        default:
            break
        }
    }
    
    func onClickCardItemClick(id index: Int) {
       
   }
    
    func onClickMedicationItemClick(id index: Int) {
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MedicationInfoMainViewController") as! MedicationInfoMainViewController        
        viewController.m_drugInfo = UserDrugs[index]
        UserDefaults.standard.set("true", forKey: "presented")
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false, completion: nil)
    }
    func onClickaddUBButton(sender: UIButton){
        if sender.titleLabel!.text! == "Add Medication"{
//            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstMedicationAddViewController") as! FirstMedicationAddViewController
//            let navController = UINavigationController(rootViewController: viewController)
//            UserDefaults.standard.set("true", forKey: "reloadProfileItems")
//            present(navController, animated: false, completion: nil)
        }
        else if sender.titleLabel!.text! == "Add Pharmacy"{
            let vc = UIStoryboard.init(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    func onClickConditionItemClick(id index: Int) {
        self.popModalView.removeFromSuperview()
        self.addConditionDetailPopView(index: index)
    }

    func onClickDoctorItemClick(id index: Int) {
        self.popModalView.removeFromSuperview()
        self.addDoctorDetailPopView(index: index)
    }
    
    func onClickPharmacyItemClick(id index: Int) {
        self.popModalView.removeFromSuperview()
        self.addPharmacyDetailPopView(index: index)
    }
    
    func onClickComunityItemClick(id index: Int) {
        self.popModalView.removeFromSuperview()
        self.addCommunityDetailPopView(index: index)
    }
    
    func onClickScheduleItemClick(id index: Int) {
        self.popModalView.removeFromSuperview()
        self.addScheduleDetailPopView(index: index)
    }
    
    func onClickAppItemClick(id index: Int) {
        self.popViewDismissal()
    }
    
    // Mark: ProfileAddConditionModalViewDelegate
    func popAddConditionViewDismissal() {
        self.popAddConditionView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    func popAddPharmacyViewAddBtnClick(MapItem: MKMapItem) {
        self.popAddPharmacyView.removeFromSuperview()
        addPharmacyToLocalDB(MapItem: MapItem)
        self.addComonPopView(index: selectIndex)
        
        DataUtils.customActivityIndicatory(self.view, startAnimate: true)
        addPharmacyToServersDB(MapItem: MapItem) { Success in
            DataUtils.getPharmacy(completionHandler: { (Status , Datas) in
                arrayPharmacy = Datas
                self.popModalView.resetMedicationList(type: self.selectIndex)
                DataUtils.customActivityIndicatory(self.view, startAnimate: false)
            })

        }
    }
    
    func addPharmacyToLocalDB(MapItem: MKMapItem){
        let number = MapItem.phoneNumber?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
     DBManager.getObject().insertPharmacyData(data: Pharmacy.init(id: 0, brand: MapItem.name!,
                                                                  address: MapItem.placemark.formattedAddress!,
                                                                  phone_number: number,
                                                                  latitude: "\(MapItem.placemark.coordinate.latitude)",
        longitude: "\(MapItem.placemark.coordinate.longitude)"))
    }
    
    func addPharmacyToServersDB(MapItem: MKMapItem,completionHandler:@escaping (_ Success:Bool)->Void ){
       
        let number = MapItem.phoneNumber?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
         print(number)
        let params = [
            "userid" : PreferenceHelper().getId(),
            "brand" : MapItem.name!,
            "choice" : "0",
            "address":MapItem.placemark.formattedAddress!,
            "phone_number":number,
            "latitude":MapItem.placemark.coordinate.latitude,
            "longitude":MapItem.placemark.coordinate.longitude
            ] as [String : Any]
        
        Alamofire.request(DataUtils.APIURL + DataUtils.Pharmacy_URL,method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                debugPrint(response);
                
                if let data = response.result.value {
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    if result == "true" {
                        completionHandler(true)
                    } else {
                        DataUtils.messageShow(view: self, message: "can't get user data", title: "")
                    }
                }
            })
    }
    
    func popAddPharmacyViewDismissal() {
        self.popAddPharmacyView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    

    func popAddConditionViewAddBtnClick() {
        self.popAddConditionView.removeFromSuperview()
        self.addComonPopView(index: selectIndex)
        popModalView.resetMedicationList(type: selectIndex)
    }
    
    // Mark: ProfileDoctorDetailModalViewDelegate
    func popDoctorDetailViewDismissal() {
        self.popDoctorDetailView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    // Mark: ProfilePharmacyDetailModalViewDelegate
    func popPharmacyDetailViewDismissal() {
        self.popPharmacyDetailView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    // Mark: ProfileCommunityDetailModalViewDelegate
    func popCommunityDetailViewDismissal() {
        self.popCommunityDetailView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    // Mark: ProfileAddCommunityModalViewDelegate
    func popAddCommunityViewDismissal() {
        self.popAddCommunityView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    func popAddCommunityViewTextClick() {
        self.popAddCommunityView.removeFromSuperview()
        self.addComonPopView(index: selectIndex)
        popModalView.resetMedicationList(type: selectIndex)
    }
    
    func popAddCommunityViewEmailClick() {
        self.popAddCommunityView.removeFromSuperview()
        self.addComonPopView(index: selectIndex)
        popModalView.resetMedicationList(type: selectIndex)
    }
    
    // Mark: ProfileScheduleDetailModalViewDelegate
    func popScheduleDetailViewDismissal() {
        self.popScheduleDetailView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    func popScheduleDetailViewNextClick() {
        self.popScheduleDetailView.removeFromSuperview()
        self.addComonPopView(index: selectIndex)
        popModalView.resetMedicationList(type: selectIndex)
    }
    
    // Mark: ProfileAddAppModalViewDelegate
    func popAddAppViewDismissal() {
        self.popAddAppView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    func popAddAppViewAddClick() {
        self.popAddAppView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    // Mark: ProfilePersonDetailModalViewDelegate
    func popPersonDetailViewDismissal(){
        self.popPersonDetailView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    func popPersonDetailAvatarImgClick(){
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .library
        config.screens = [.library, .photo]
        config.showsCrop = .rectangle(ratio: (1/1))
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.wordings.next = "next"
        config.library.maxNumberOfItems = 5
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }
            
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    self.popPersonDetailView.avatarUIV.image = photo.image
                    selAvatarImg = photo.image
                    self.updatePicture(image: photo.image)
                    break
                case .video:
                    //
                    break
                }
                picker.dismiss(animated: true, completion: nil)
            }
        }
        present(picker, animated: true, completion: nil)
    }
    
    func updatePicture(image:UIImage){
        let preference = PreferenceHelper()
        let id = preference.getId()
        let data = UIImageJPEGRepresentation(image,0.5)!
        let parameters = [
            "choice":6,
            "userid": "\(id)"
            ] as [String : Any]
        
        let url = DataUtils.APIURL + DataUtils.AUTH_URL
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(data, withName: "name", fileName: "image.jpg", mimeType: "image/jpg")
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    print(response.result.value ?? "")
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        
    }

    func showController(message:String){
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.visualEffectView.alpha = 0.00
            mTabView.isHidden = false
            self.settingFAB.isHidden = false
            self.popPersonDetailView.removeFromSuperview()
            DataUtils.customActivityIndicatory(self.view,startAnimate: true)
            self.getUserData(completionHandler: { success in
                if success{
                    DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                    let preference = PreferenceHelper()
                    let url = URL(string: DataUtils.PROFILEURL + preference.getUserImage()!)
                    self.imgProfile.kf.setImage(with: url)
                    self.imgProfile.contentMode = .scaleAspectFit
                    self.lblMemberSince.text = preference.getFirstName()! + " " + preference.getLastName()!
                }
            })
          
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getUserData(completionHandler:@escaping (_ Success:Bool)->Void){
        let params = [
            "email" : DataUtils.getEmail()!,
            "password" : DataUtils.getPassword()!,
            "choice" : "1"
            ] as [String : Any]
     
        Alamofire.request(DataUtils.APIURL + DataUtils.AUTH_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                debugPrint(response);
                
                if let data = response.result.value {
                    let json : [String:Any] = data as! [String : Any]
                    //let statusMsg: String = json["status_msg"] as! String
                    //self.showResultMessage(statusMsg)
                    //self.showGraph(json)
                    let result = json["status"] as? String
                    if result == "true" {
                        DataUtils.setSkipButton(time: true)
                        let patientInfo = PatientInfo.init(json: json["userinfo"] as! [String:Any])
                        patientInfo.saveUserInfo()
                        completionHandler(true)
                    } else {
                        DataUtils.messageShow(view: self, message: "can't get user data", title: "")
                    }
                }
            })
    }
    
    func ClickSaveUB(firstName: String, lastName: String?, birth: String, phone: String, address: String) {
        let preference = PreferenceHelper()
        let id = preference.getId()
        let parameters = [
            "choice":7,
            "userid": "\(id)",
            "first_name": firstName,
            "last_name": lastName ?? "",
            "birthday": birth,
            "phone_number": phone,
            "address": address
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.AUTH_URL, method: .post, parameters: parameters)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                
                if let data = response.result.value {
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    let message = json["message"] as! String
                    if result == "true"
                    {
                        self.showController(message:message)
                    }
                    else
                    {
                        DataUtils.messageShow(view: self, message: "can't update profile", title: "")
                    }
                }
            })
    }
    
    
    
    // Mark: ProfileAddCardModalViewDelegate
    func popAddCardViewDismissal() {
        self.popVerifyCardView.removeFromSuperview()
        self.addComonPopView(index: selectIndex)
        popModalView.resetMedicationList(type: selectIndex)
    }
    
    func popAddCardViewVerifyBtnClick() {
        self.popVerifyCardView.removeFromSuperview()
        self.addComonPopView(index: selectIndex)
        popModalView.resetMedicationList(type: selectIndex)
    }
    
    // Mark: ProfileSettingModalViewDelegate
    func popSettingViewDismissal() {
        self.popSettingView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        mTabView.isHidden = false
        settingFAB.isHidden = false
    }
    
    func popSettingViewSignBtnClick() {
        self.popSettingView.removeFromSuperview()
        visualEffectView.alpha = 0.0
        mTabView.isHidden = false
        settingFAB.isHidden = false
        DBManager.getObject().deleteTmpDrug()
        self.SignOutStuff()
     }
    
    func SignOutStuff(){
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingScreenViewController") as! LandingScreenViewController
        PatientInfo.DeleteUserInfo()
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: false, completion: {
            self.navigationController?.viewControllers.removeAll()
        })
    }
    
    
   
    
    func popSettingViewBtnsClick(name: String) {
        switch name {
        case "Terms & Conditions":
            do {
                self.popSettingView.removeFromSuperview()
                self.addSettingTermPopView()
                self.popSettingTermView.titleUL.text = "Terms & Conditions"
                self.popSettingTermView.textUV.text = arrayOfContent[0]
            }
            break
        case "Disclaimer":
            do {
                self.popSettingView.removeFromSuperview()
                self.addSettingTermPopView()
                self.popSettingTermView.titleUL.text = "Disclaimer"
                self.popSettingTermView.textUV.text = arrayOfContent[2]
            }
            break
        case "iOS Notification Settings":
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                } else {
                    UIApplication.shared.openURL(settingsUrl as URL)
                }
            }
            break
        case "Privacy Policy":
            do {
                self.popSettingView.removeFromSuperview()
                self.addSettingTermPopView()
                self.popSettingTermView.titleUL.text = "Privacy Policy"
                self.popSettingTermView.textUV.text = arrayOfContent[1]
            }
            break
        case "   Snooze Time\n":
            do {
                self.popSettingView.removeFromSuperview()
                let snooze = popSettingView.snooze
                
                self.addSettingSnoozePopView(snooze)
            }
        case "Password":
            do {
                self.popSettingView.removeFromSuperview()
                self.addSettingPasswordPopView()
            }
            break
        case "Email Address":
            do {
                self.popSettingView.removeFromSuperview()
                self.addSettingEmailPopView()
            }
            break
        default:
            break
        }
    }
    
    // Mark: SettingTermModalViewDelegate
    func popSettingTermModalViewDismissal() {
        self.popSettingTermView.removeFromSuperview()
        self.addSettingPopView()
    }
    
    // Mark: SettingSnoozeModalViewDelegate
    func popSettingSnoozeModalViewDismissal() {
        self.popSettingSnoozeView.removeFromSuperview()
        self.addSettingPopView()
    }
    
    func popSettingSnoozeAddView() {
     
    }
    
    // Mark: SettingEmailModalViewDelegate
    func popSettingEmailModalViewDismissal() {
        self.popSettingEmailView.removeFromSuperview()
        self.addSettingPopView()
    }
    
    func popSettingEmailSaveView(CurrentEmail: String, newEmail: String, ConfirmEmail: String) {
        let params = [
            "email" : DataUtils.getEmail() ?? "",
            "currentemail" : CurrentEmail,
            "choice" : 8,
            "newemail":newEmail
             ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.AUTH_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in

                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                if let data = response.result.value {
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    if result == "true" {
                        let message = json["message"] as! String
                        let controller = UIAlertController(title: "Success", message: "\(message)", preferredStyle: .alert)
                        controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: { sucess in
                            self.SignOutStuff()
                        }))
                        self.present(controller, animated: true, completion: nil)
                    } else {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }                }
            })
    }

    
    // Mark: SettingPasswordModalViewDelegate
    func popSettingPasswordModalViewDismissal() {
        self.popSettingPasswordView.removeFromSuperview()
        self.addSettingPopView()
    }
    
    func popSettingPasswordSaveView(CurrentPassword: String, newPassword: String, ConfirmPassword: String) {
        if newPassword != ConfirmPassword{
            DataUtils.messageShow(view: self, message: "Password does not Match..", title: "Error")
        }
        
        let params = [
            "email" : DataUtils.getEmail() ?? "",
            "newpassword" : newPassword,
            "choice" : "3",
            "currentpassword": CurrentPassword
            
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.AUTH_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                if let data = response.result.value {
                    let json : [String:Any] = data as! [String : Any]
                    let result = json["status"] as? String
                    if result == "true" {
                        let message = json["message"] as! String
                        let controller = UIAlertController(title: "Success", message: "\(message)", preferredStyle: .alert)
                        controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: { sucess in
                          self.SignOutStuff()
                        }))
                        self.present(controller, animated: true, completion: nil)
                    } else {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
}
