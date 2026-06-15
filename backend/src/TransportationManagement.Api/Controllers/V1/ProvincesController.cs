using Microsoft.AspNetCore.Mvc;

namespace TransportationManagement.Api.Controllers.V1;

[ApiController]
[Route("api/v1/provinces")]
public class ProvincesController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll() => StatusCode(StatusCodes.Status501NotImplemented);

    [HttpGet("{id:guid}")]
    public IActionResult GetById(Guid id) => StatusCode(StatusCodes.Status501NotImplemented);

    [HttpPost]
    public IActionResult Create() => StatusCode(StatusCodes.Status501NotImplemented);

    [HttpPut("{id:guid}")]
    public IActionResult Update(Guid id) => StatusCode(StatusCodes.Status501NotImplemented);

    [HttpDelete("{id:guid}")]
    public IActionResult Delete(Guid id) => StatusCode(StatusCodes.Status501NotImplemented);
}
