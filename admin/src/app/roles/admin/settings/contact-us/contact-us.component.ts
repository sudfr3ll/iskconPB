import { Component, OnInit } from '@angular/core';
import { SettingsService } from 'src/app/services/settings.service';

@Component({
  selector: 'app-contact-us',
  templateUrl: './contact-us.component.html',
  styleUrls: ['./contact-us.component.scss']
})
export class ContactUsComponent implements OnInit {

  data: any;

  constructor(
    private settingsService: SettingsService
  ) { }

  async ngOnInit() {
    if(!this.data) {
      this.data = await this.settingsService.getContactUsData();
      // console.log(this.data);
      
    }
  }

  async onSubmit() {
    const update = await this.settingsService.updateContactUsData(this.data);
    if(update) {
      console.log("settings updated!")
    }
  }

}
