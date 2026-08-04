import { Component, OnInit } from '@angular/core';
import { SettingsService } from 'src/app/services/settings.service';

@Component({
  selector: 'app-social-media',
  templateUrl: './social-media.component.html',
  styleUrls: ['./social-media.component.scss']
})
export class SocialMediaComponent implements OnInit {

  data: any;

  constructor(
    private settingsService: SettingsService
  ) { }

  async ngOnInit() {
    if(!this.data) {
      this.data = await this.settingsService.getSocialMediaData();
    }
  }

  async onSubmit() {
    const update = await this.settingsService.updateSocialMediaData(this.data);
    if(update) {
    }
  }

}
