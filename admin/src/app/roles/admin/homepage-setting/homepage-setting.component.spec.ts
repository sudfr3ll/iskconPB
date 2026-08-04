import { ComponentFixture, TestBed } from '@angular/core/testing';

import { HomepageSettingComponent } from './homepage-setting.component';

describe('HomepageSettingComponent', () => {
  let component: HomepageSettingComponent;
  let fixture: ComponentFixture<HomepageSettingComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ HomepageSettingComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(HomepageSettingComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
