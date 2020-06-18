//////////////
/// Help Texts
//////////////

// Validation (?)
const Map<String, String> validationHelpTexts = {
  'whattodo':
      'The recording should be a voice donation from one of our donors like you 😉. We need your help to probe into its validity by checking if the recording is truly a human voice that reads the text displayed correspondingly and entirely. After your evaluation, if you deem the recording valid then you press the "Validate" button else you press the "Invalidate" button. Optionally, you can give us the reason for your evaluation after you pressed any of this buttons.',
  'afterwards':
      'After you have submitted your evaluation, we promote or demote the ranking of the donation accordingly.',
  'privacy':
      'We do not collect any traceable information from you. Hence, it is impossible to associate you(specifically) with the data you gave at the metadata screen. The metadata excluding the nickname is merely used to classify voice donations. Your nickname is stored only locally in your device to aid the multi-user feature. Thus, we do not save it in our servers.',
};

// Donation (?)
const Map<String, String> donationHelpTexts = {
  'whattodo':
      'We need your help with a voice donation. We have provided a text that you should read while you record it. You can discard the recording to make a new one. You can also listen to it before you submit.',
  'afterwards':
      'After you have submitted your donation, we store it in our server as unvalidated pending its validation from our friends like you 😉. After absolute validation, we promote it to validated.',
  'privacy':
      'We do not collect any traceable information from you. Hence, it is impossible to associate you(specifically) with the data you gave at the metadata screen. The metadata excluding the nickname is merely used to classify voice donations. Your nickname is stored only locally in your device to aid the multi-user feature. Thus, we do not save it in our servers.',
};

// Nickname (?)
const Map<String, String> nicknameHelpText = {
  'help':
      'Any name you can recall. e.g "winterknight". We do not store your nickname on our servers. It is sored only locally in your device to aid wazobia\'s multi-user feature.',
};

// Proceded (?)
const Map<String, String> proceedHelpText = {
  'help':
      'When you press the "Proceed" button, you will be signed in anonymously to our server, which means that you will get a temporary authentication token that allows your donations and validations gain access into our database. It is a measure to protect our server from hackers. Your authentication is valid until you delete this user or switch to another user. All the metadata collected in this page are non-traceable. Hence, it is impossible to associate you(specifically) with them. The metadata excluding the nickname is merely used to classify voice donations. Your nickname is stored only locally in your device to aid the multi-user feature. Thus, we do not save it in our servers.',
};

////////////////////////
/// Terms and Conditions
////////////////////////

const String termsAndConditionsTextTentative =
    'You must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions';

const String termsAndConditionsText = """Wazobia Legal Terms

Effective  MM/DD/YYYY [TBD] 

Through Wazobia, you can donate your voice and validate other donations. We need to build an open-source voice database for African English dialects that anyone can use to make innovative voice recognition apps for devices and the web.
You may only participate in Wazobia if you agree to these Terms.

1. Eligibility
Wazobia is open to anyone over the age of 19. If you are 19 or under, you must have your parent or guardian’s consent and they must supervise your participation in Wazobia.

2. Your Contributions
We make Wazobia database available under the Creative Commons CC0 public domain dedication. That means it’s public and we’ve waived all copyrights to the extent we can under the law. If you participate in Wazobia, we require that you do the same. You must agree that Wazobia may offer all of your Contributions (recording and validations) to the public under the CC0 public domain dedication.
In order to participate in Wazobia also requires that you make two assurances:
First, that your Contributions are entirely your own creation.
Second, that your Contributions do not infringe on any third parties’ rights.
If you cannot make these assurances, you may not participate in Wazobia.

3. Your Account [From App]
You do not have to create an account to participate in Wazobia. You will be signed in anonymously to our server, which means that you will get a temporary authentication token that allows your donations and validations gain access into our database. It is a measure to protect our server from hackers. Your authentication is valid until you delete a user or switch to another user. All the metadata collected in this page are non-traceable. Hence, it is impossible to associate you(specifically) with them. The metadata excluding the nickname is merely used to classify voice donations. Your nickname is stored only locally in your device to aid the multi-user feature. Thus, we do not save it in our servers.

4. Disclaimers
By participating in Wazobia, you agree that Wazobia will not be liable in any way for any inability to use Wazobia or for any claim arising out of these terms. Wazobia specifically disclaims the following: Indirect, special, incidental, consequential, or exemplary damages Direct or indirect damages for loss of goodwill, work stoppage, lost profits, loss of data, or computer malfunction
Any liability under this agreement is limited to \$500. You agree to indemnify and hold Wazobia harmless for any liability or claim that comes results from your participation in Wazobia.
Wazobia provides the service “as is.” Wazobia specifically disclaims any legal guarantees or warranties such as “merchantability,” “fitness for a particular purpose,” “non-infringement,” and warranties arising out of a course of dealing, usage or trade.

5. Notices of Infringement [TBD]
If you think something in Wazobia infringes your copyright or trademark rights, please see our policy for how to report infringement.

6. Updates
Every once in a while, Wazobia may decide to update these Terms. We will post the updated Terms online.
If you continue to use Wazobia after we post updated Terms, you agree to accept that this constitutes your acceptance of such changes. We will post an effective date at the top of this page to make it clear when we made our most recent update.

7. Termination
Wazobia can suspend or end anyone’s access to Wazobia at any time for any reason. 
The recordings you submit to Wazobia will remain publicly available as part of Wazobia, even if we terminate or suspend your access.

8. Governing Law
Nigerian law applies to these Terms. These terms are the entire agreement between you and Wazobia.
""";

////////////
/// About Us
////////////

const String aboutUsText =
    'This application is developed by students of Computer Engineering Department, Federal University of Technology, Minna, in collaboration with ITU, under their Machine Learning and 5G focus group. It is used to collect voice data for the African Automatic Speech Recognition project.';
