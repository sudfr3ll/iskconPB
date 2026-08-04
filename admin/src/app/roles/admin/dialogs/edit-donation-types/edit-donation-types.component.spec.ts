import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditDonationTypesComponent } from './edit-donation-types.component';

describe('EditDonationTypesComponent', () => {
  let component: EditDonationTypesComponent;
  let fixture: ComponentFixture<EditDonationTypesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EditDonationTypesComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EditDonationTypesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
